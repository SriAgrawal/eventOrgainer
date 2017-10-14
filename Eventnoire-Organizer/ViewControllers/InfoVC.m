//
//  InfoVC.m
//  Eventnoire-Attendee
//
//  Created by Aiman Akhtar on 03/04/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//
#import "NSDictionary+NullChecker.h"
#import "UIImageView+WebCache.h"
#import <GoogleMaps/GoogleMaps.h>
#import "EventCalendarModel.h"
#import "RequestTimeOutView.h"
#import "EventCalendarModel.h"
#import "InfoTableViewCell.h"
#import "ServiceHelper.h"
#import "AppDelegate.h"
#import "InfoVC.h"
#import "Macro.h"

static NSString *cellIdentifier = @"InfoTableViewCell";

@interface InfoVC ()<UITableViewDataSource,UITableViewDelegate,GMSMapViewDelegate>{
    NSMutableArray *eventInfoArray;
}

@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *toTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (assign, nonatomic) BOOL isDynamicHeight;

@end

@implementation InfoVC

#pragma mark - UIViewController Life Cycle & Memory Management

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialsetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method

- (void)initialsetup {
    //set dynamic height
    self.infoTableView.estimatedRowHeight = 40;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    eventInfoArray = [NSMutableArray new];
    
    [self ticketIndoCall];
}

#pragma mark - UITableView Delegate & Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.isDynamicHeight)? UITableViewAutomaticDimension : 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [eventInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoTableViewCell *cell = (InfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    EventCalendarModel *objModel = [eventInfoArray firstObject];
    
    (self.isDynamicHeight) ? [cell.moreButton setTitle:@"less.." forState:UIControlStateNormal] : [cell.moreButton setTitle:@"more.." forState:UIControlStateNormal];
    [cell.moreButton setHidden:!objModel.isMoreNeeded];
    
    cell.descriptionLabel.text = objModel.eventDescription;
    
    [cell.moreButton addTarget:self action:@selector(moreButtonAction :) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UIButton Action Methods

- (void) moreButtonAction : (UIButton *) sender {
    sender.selected = !sender.selected;
    
    self.isDynamicHeight = sender.selected;
    
    [self.infoTableView reloadData];
}

#pragma mark - Service Implemention

-(void)ticketIndoCall
{
    NSMutableDictionary *eventDict = [NSMutableDictionary new];
    [eventDict setValue:self.selectedEventId forKey:pBookID];
    
    if ([APPDELEGATE location]) {
        [eventDict setValue:[NSString stringWithFormat:@"%f",[APPDELEGATE location].coordinate.latitude] forKey:pLatitude];
        [eventDict setValue:[NSString stringWithFormat:@"%f",[APPDELEGATE location].coordinate.latitude] forKey:pLongitude];
    }
    [self apiCallForEvent:eventDict andServiceName:eventListApi];
}

-(void)apiCallForEvent:(NSMutableDictionary *)eventDict andServiceName:(NSString *)serviceName {
    
    [[ServiceHelper sharedServiceHelper] callApiWithParameter:eventDict apiName:serviceName andApiType:POST andIsRequiredHud:YES WithComptionBlock:^(NSDictionary *result, NSError *error){
        
        if (!error) {
            //Success and 200 responseCode
            if ([[result objectForKeyNotNull:pResponseCode expectedObj:@"0"] intValue] == 200) {
                NSMutableArray *eventDetail = [result objectForKeyNotNull:pEvents expectedObj:[NSArray array]];
                
                for (NSDictionary *dict in eventDetail) {
                    EventCalendarModel *obj = [EventCalendarModel eventInfoDetails:dict];
                    [eventInfoArray addObject:obj];
                }
                
                [self addEventDataOnView];
            }
            
        }else if (error.code == 100) {
            //Success but other than 200 responseCode
            NSString *errorMessage = [result objectForKeyNotNull:pResponseMessage expectedObj:[NSString string]];
            [RequestTimeOutView showWithMessage:errorMessage forTime:2.0];
        }else {
            //Error
            NSString *errorMessage = error.localizedDescription;
            [RequestTimeOutView showWithMessage:errorMessage forTime:2.0];
        }
    }];
}


-(void)addEventDataOnView {
    
    EventCalendarModel *objModel = [eventInfoArray firstObject];
    
    //set camera position
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[objModel.eventLatitude doubleValue]
                                                            longitude:[objModel.eventLongitude doubleValue]
                                                                 zoom:6];
    [self.mapView setCamera:camera];
    self.mapView.myLocationEnabled = NO;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([objModel.eventLatitude doubleValue], [objModel.eventLongitude doubleValue]);
    marker.map = self.mapView;
    
    //set label text
    self.eventNameLabel.text = objModel.eventTitle;
    self.fromDateLabel.text = objModel.eventStartDateModified;
    self.fromTimeLabel.text = objModel.eventStartTimeModified;
    self.toDateLabel.text = objModel.eventEndDateModified;
    self.toTimeLabel.text = objModel.eventEndTimeModified;
    self.locationNameLabel.text = objModel.eventVenueName;
    self.distanceLabel.text = [objModel.eventDistance stringByAppendingString:objModel.eventDistanceIn];
    
    //set imageView image
     [self.eventImageView sd_setImageWithURL:[NSURL URLWithString:objModel.eventImageUrl] placeholderImage:[UIImage imageNamed:@"eventPlaceholder"]];
    
    [_infoTableView reloadData];
}

#pragma mark - UIButton Action Method

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
