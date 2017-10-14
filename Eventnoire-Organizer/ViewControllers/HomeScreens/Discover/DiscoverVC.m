//
//  DiscoverVC.m
//  Eventnoire-Organizer
//
//  Created by Aiman Akhtar on 10/04/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import "DiscoverCollectionViewCell.h"
#import "NSDictionary+NullChecker.h"
#import "OptionsPickerSheetView.h"
#import "RequestTimeOutView.h"
#import "EventCalendarModel.h"
#import "QRCodeScannerVC.h"
#import "DatePickerManager.h"
#import "DashboardModal.h"
#import "ServiceHelper.h"
#import "AppDelegate.h"
#import "DiscoverVC.h"
#import "AppUtility.h"
#import "SettingVC.h"
#import "Macro.h"

static NSString *cellIdentifier = @"DiscoverCollectionViewCell";

@interface DiscoverVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray *eventListArray;
    NSMutableArray *eventDateArray;

    NSString *selectedEventId;
    NSString *startDateEvent;
    NSString *endDateEvent;
    

}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *selectEventButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (strong, nonatomic)  DashboardModal *dashboardModal;

@end

@implementation DiscoverVC

#pragma mark - UIViewController Life Cycle & Memory Management

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    eventListArray = [[NSMutableArray alloc]init];

    [self initialSetup];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}


-(void)fetchDashboardInfo{
    NSMutableDictionary *eventDict = [NSMutableDictionary new];
    [eventDict setValue:@"" forKey:pEventID];
    [eventDict setValue:@"" forKey:pEventDate];
    [self apiCallForFetchingDashboardDetail:eventDict andServiceName:dashBoardAPI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void) initialSetup {
    //Initialise array

    [self fetchDashboardInfo];
}

#pragma mark - UICollectionView Delegate & Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DiscoverCollectionViewCell *cell = (DiscoverCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.item) {
        case 0:{
            [cell.iconImageView setImage:[UIImage imageNamed:@"h1"]];
            cell.iconNameLabel.text = @"Total Attendees";
            if (self.dashboardModal.totalAttendies) {
                cell.iconNumberLabel.text = [NSString stringWithFormat:@"%@",self.dashboardModal.totalAttendies];
            }
            cell.iconNumberLabel.textColor = [UIColor redColor];
        }
            break;
        case 1:{
            [cell.iconImageView setImage:[UIImage imageNamed:@"h2"]];
            cell.iconNameLabel.text = @"Check-Ins";
            if (self.dashboardModal.totalCheckins) {
                cell.iconNumberLabel.text = [NSString stringWithFormat:@"%@",self.dashboardModal.totalCheckins];
            }
            cell.iconNumberLabel.textColor = [UIColor redColor];
        }
            break;
        case 2:{
            [cell.iconImageView setImage:[UIImage imageNamed:@"h3"]];
            cell.iconNameLabel.text = @"Total Ticket Sell";
            if (self.dashboardModal.totalSell) {
                cell.iconNumberLabel.text = [NSString stringWithFormat:@"%@",self.dashboardModal.totalSell];
            }
            cell.iconNumberLabel.textColor = [UIColor redColor];
        }
            break;
        case 3:{
            [cell.iconImageView setImage:[UIImage imageNamed:@"h4"]];
            cell.iconNameLabel.text = @"Attendance";
            if (self.dashboardModal.totalAttendance) {
                cell.iconNumberLabel.text = [NSString stringWithFormat:@"%@ %%",self.dashboardModal.totalAttendance];
            }
            cell.iconNumberLabel.textColor = [UIColor redColor];
        }
            break;
        default:
            break;
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(windowWidth / 2 - 20, windowWidth / 2 - 20);
}

#pragma mark - UIButton Action Methods

- (IBAction)selectEventButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([eventListArray count]) {
        NSMutableArray *eventNameList = [NSMutableArray new];
        
        for (int count=0; count<eventListArray.count; count++) {
            EventCalendarModel *objModel = [eventListArray objectAtIndex:count];
            [eventNameList addObject:objModel.eventTitle];
        }
        
        [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:eventNameList andCurrentSelectionIndex:0   AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
            EventCalendarModel *objModel = [eventListArray objectAtIndex:selectedIndex];
            
            selectedEventId = objModel.eventId;
            [self.selectEventButton setTitle:selectedText forState:UIControlStateNormal];
        }];
    }else {
        [self fetchEventRequest];
    }
}

- (IBAction)dateButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.selectEventButton.titleLabel.text isEqualToString:@"Event"]) {
        [RequestTimeOutView showWithMessage:no_event_selected forTime:2.0];
    }else{
        for (int count=0; count<[eventListArray count]; count++) {
            EventCalendarModel *objModel = [eventListArray objectAtIndex:count];
            
            if ([self.selectEventButton.titleLabel.text isEqualToString:objModel.eventTitle]) {
                startDateEvent = objModel.eventStartDateModified;
                endDateEvent = objModel.eventEndDateModified;
                
                [self addDatesForSelectedEvent];
                
                break;
            }
        }
    }
}

-(void)addDatesForSelectedEvent{
    
    eventDateArray = [NSMutableArray new];
    [eventDateArray addObject:startDateEvent];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [formatter dateFromString:startDateEvent];
    NSDate *endDate = [formatter dateFromString:endDateEvent];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *difference = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    
    if ([[NSString stringWithFormat:@"%ld",(long)[difference day]]intValue] !=0) {
        
        for (int count = 0; count< [[NSString stringWithFormat:@"%ld",(long)[difference day]]intValue]; count ++) {
            
            NSDateComponents *components= [[NSDateComponents alloc] init];
            [components setDay:1];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *dateIncremented= [calendar dateByAddingComponents:components toDate:startDate options:0];
            
            NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
            [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSString *stringFromDate = [myDateFormatter stringFromDate:dateIncremented];
            [eventDateArray addObject:stringFromDate];
            startDate = [myDateFormatter dateFromString:stringFromDate];
        }
        
        [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:eventDateArray andCurrentSelectionIndex:0  AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
            
            [self.dateButton setTitle:selectedText forState:UIControlStateNormal];
        }];
    }
}

- (IBAction)filterButtonAction:(id)sender {
    
    if ([self.selectEventButton.titleLabel.text isEqualToString:@"Event"] ) {
        [RequestTimeOutView showWithMessage:no_event_selected forTime:2.0];
    }else if ([self.dateButton.titleLabel.text isEqualToString:@"Date"]){
        [RequestTimeOutView showWithMessage:blank_Event_Date forTime:2.0];
    }else{
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"] ;
        NSDate *date = [dateFormatter dateFromString:self.dateButton.titleLabel.text];
        
        NSMutableDictionary *eventDict = [NSMutableDictionary new];
        [eventDict setValue:selectedEventId forKey:pEventID];
        [eventDict setValue:[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]] forKey:pEventDate];
        
        [self apiCallForFetchingDashboardDetail:eventDict andServiceName:dashBoardAPI];
    }
    
}

- (IBAction)scannerButtonAction:(id)sender {
    [self.view endEditing:YES];
    QRCodeScannerVC *codeScannerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCodeScannerVC"];
    [self.navigationController pushViewController:codeScannerVC animated:YES];
}

-(void)fetchEventRequest {
    NSMutableDictionary *createToDoDict = [NSMutableDictionary new];
    [self apiCallForFetchingUserEvent:createToDoDict andServiceName:eventListOrganizerApi];
}

-(void)apiCallForFetchingDashboardDetail:(NSMutableDictionary *)eventDict andServiceName:(NSString *)serviceName {
    [[ServiceHelper sharedServiceHelper] callApiWithParameter:eventDict apiName:serviceName andApiType:POST andIsRequiredHud:YES WithComptionBlock:^(NSDictionary *result, NSError *error) {
        
        if (!error) {
            //Success and 200 responseCode
            
            self.dashboardModal = [DashboardModal parseDashboardModal:[result objectForKeyNotNull:pUserDetail expectedObj:[NSDictionary dictionary]]];
            
            [_collectionView reloadData];
            
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


-(void)apiCallForFetchingUserEvent:(NSMutableDictionary *)request andServiceName:(NSString *)serviceName {
    
    [[ServiceHelper sharedServiceHelper] callApiWithParameter:request apiName:serviceName andApiType:POST andIsRequiredHud:YES WithComptionBlock:^(NSDictionary *result, NSError *error) {
        
        if (!error) {
            //Success and 200 responseCode
            NSArray *listArray = [result objectForKeyNotNull:pUserDetail expectedObj:[NSArray array]];
            for (NSDictionary *dict in listArray) {
                EventCalendarModel *eventDetail = [EventCalendarModel eventNameDetails:dict];
                [eventListArray addObject:eventDetail];
            }
            
            
            if ([eventListArray count]) {
                NSMutableArray *eventNameList = [NSMutableArray new];
                
                for (int count=0; count<eventListArray.count; count++) {
                    EventCalendarModel *objModel = [eventListArray objectAtIndex:count];
                    [eventNameList addObject:objModel.eventTitle];
                }
                
                [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:eventNameList andCurrentSelectionIndex:0   AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
                    EventCalendarModel *objModel = [eventListArray objectAtIndex:selectedIndex];
                    
                    selectedEventId = objModel.eventId;
                    [self.selectEventButton setTitle:selectedText forState:UIControlStateNormal];
                }];
            }else {
                NSString *successMessage = [result objectForKeyNotNull:pResponseMessage expectedObj:[NSString string]];
                [RequestTimeOutView showWithMessage:successMessage forTime:2.0];
            }
            
        }else if (error.code == 100) {
            //Success but other than 200 responseCode
            NSString *errorMessage = [result objectForKeyNotNull:pResponseMessage expectedObj:[NSString string]];
            [RequestTimeOutView showWithMessage:errorMessage forTime:2.0];
        }else {
            //Error
            NSString *errorMessage = error.localizedDescription;
            [RequestTimeOutView showWithMessage:errorMessage forTime:2.0];        }
    }];
}

@end
