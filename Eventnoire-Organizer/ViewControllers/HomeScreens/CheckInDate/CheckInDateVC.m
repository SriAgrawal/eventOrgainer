//
//  CheckInDateVC.m
//  Eventnoire-Organizer
//
//  Created by Aiman Akhtar on 10/04/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import "UITableView+SetIndicatorAndLabelInMiddle.h"
#import "CheckInDateTableViewCell.h"
#import "NSDictionary+NullChecker.h"
#import "CheckInDateDetailVC.h"
#import "RequestTimeOutView.h"
#import "CheckInDetailModal.h"
#import "QRCodeScannerVC.h"
#import "CheckInDateVC.h"
#import "ServiceHelper.h"
#import "AppDelegate.h"
#import "SettingVC.h"
#import "Macro.h"

static NSString *cellIdentifier = @"CheckInDateTableViewCell";

@interface CheckInDateVC ()<UITableViewDelegate,UITableViewDataSource> {
    PAGE paginationData;
}

@property (weak, nonatomic) IBOutlet UITableView *checkInDatetableView;

@property (strong, nonatomic) NSMutableArray *checkInDataArray;

//Refresh
@property (nonatomic, strong) UIRefreshControl *refereshControl;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation CheckInDateVC

#pragma mark - UIViewController Life Cycle & memory Management

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initalSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method

- (void) initalSetup {
    //dynamic row height
    self.checkInDatetableView.estimatedRowHeight = 400;
    //self.checkInDatetableView.alwaysBounceVertical = NO;
    
    self.checkInDataArray = [NSMutableArray array];
    
    [self.checkInDatetableView startIndicatorInMiddleOfView];

    //Pagination
    paginationData.currentPage = 1;
    paginationData.totalNumberOfPages = 0;
    self.isLoading = NO;
    
    //Refresh Data
    self.refereshControl = [[UIRefreshControl alloc] init];
    [self.checkInDatetableView addSubview:self.refereshControl];
    [self.refereshControl addTarget:self action:@selector(refreshTableData:) forControlEvents:UIControlEventValueChanged];
    
    //Call Api
    [self checkInDataRequest];
}

#pragma mark - UITableView Delegate & Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self.checkInDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckInDateTableViewCell *cell = (CheckInDateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    CheckInDetailModal *checkDetail = [self.checkInDataArray objectAtIndex:indexPath.row];
    
    cell.bookIdLabel.text = checkDetail.bookID;
    cell.eventNameLabel.text = checkDetail.eventName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckInDateDetailVC *checkInDateDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckInDateDetailVC"];
    checkInDateDetailVC.checkInDetail = [self.checkInDataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:checkInDateDetailVC animated:YES];
}

- (IBAction)scannerButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    QRCodeScannerVC *codeScannerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCodeScannerVC"];
    [self.navigationController pushViewController:codeScannerVC animated:YES];
}

#pragma mark - Refresh Data Method
    
-(void)refreshTableData:(NSNotification *)notify {
    paginationData.currentPage = 1;
    paginationData.totalNumberOfPages = 0;
    
    [self checkInDataRequest];
}
    
#pragma mark UIScrollView delegates
    
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (self.isLoading)
    return;
    
    if (currentOffset - maximumOffset >= SCROLLUPREFRESHHEIGHT) {
        
        if (paginationData.totalNumberOfPages > paginationData.currentPage) {
            
            paginationData.currentPage++;
            [self checkInDataRequest];
        }
    }
}

#pragma mark - Service Implemention

-(void)checkInDataRequest {
    
    NSMutableDictionary *checkInDataDict = [NSMutableDictionary new];
    [checkInDataDict setValue:[NSNumber numberWithInt:paginationData.currentPage] forKey:pPageNumber];
    
    self.isLoading = YES;
    
    [self apiCallForCheckInDetail:checkInDataDict andServiceName:checkInDataApi];
}

-(void)apiCallForCheckInDetail:(NSMutableDictionary *)requestDictonary andServiceName:(NSString *)serviceName {
    
    [[ServiceHelper sharedServiceHelper] callApiWithParameter:requestDictonary apiName:serviceName andApiType:POST andIsRequiredHud:NO WithComptionBlock:^(NSDictionary *result, NSError *error) {
        //Stop Refresh Data Process
        [self.refereshControl endRefreshing];
        [self.checkInDatetableView stopIndicator];

        self.isLoading = NO;
        
        if (!error) {
            
            if (paginationData.currentPage == 1)
                [self.checkInDataArray removeAllObjects];
            
            //Success and 200 responseCode
            NSArray *checkInDataArray = [result objectForKeyNotNull:pCheckInDetail expectedObj:[NSArray array]];
            
            if ([self.checkInDataArray count] || [checkInDataArray count]) {
                self.checkInDatetableView.backgroundView = nil;
                
                for (NSDictionary *checkInDict in checkInDataArray)
                    [self.checkInDataArray addObject:[CheckInDetailModal parseCheckListDetail:checkInDict]];
            }else {
                [self.checkInDatetableView setTextInMiddleOfView:[result objectForKeyNotNull:pResponseMessage expectedObj:@"No data found."]];
            }

            
            NSDictionary *paginationDict = [result objectForKeyNotNull:pPagination expectedObj:[NSDictionary dictionary]];
            
            //Pagination Detail
            paginationData.currentPage = [[paginationDict objectForKeyNotNull:pPageNumber expectedObj:[NSString string]] intValue];
            paginationData.totalNumberOfPages = [[paginationDict objectForKeyNotNull:pMaximumPages expectedObj:[NSString string]] intValue];
            paginationData.totalNumberOfRecord = [[paginationDict objectForKeyNotNull:pTotalNumberOfRecords expectedObj:[NSString string]] intValue];
            
            [self.checkInDatetableView reloadData];
            
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
