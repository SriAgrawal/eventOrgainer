//
//  eveCalendarVC.m
//  Eventnoire-Organizer
//
//  Created by Ashish Kumar Gupta on 11/05/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import "eveCalendarVC.h"
#import "Macro.h"
#import "FSCalendar.h"
#import "EventCalendarModel.h"
#import "ServiceHelper.h"
#import "eveCalendarCell.h"
#import "RequestTimeOutView.h"
#import "NSDictionary+NullChecker.h"

@interface eveCalendarVC ()<FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource>{
    
    NSString *selectedMonthTimeStamp;
    NSMutableArray *eventDetailArray;
    NSMutableArray *eventDisplayOnCalendarArray;
    NSMutableArray *eventArrayTableView;
    
    NSString *start;
    NSString *end;
    
    NSString *selectedDate;
    
    EventCalendarModel *objModelEvent;

}

@property (strong, nonatomic) IBOutlet FSCalendar *calenderView;
@property(nonatomic,retain)IBOutlet UITableView *eventTableView;
@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) NSCalendar *gregorian;

- (void)previousClicked:(id)sender;
- (void)nextClicked:(id)sender;
@end

@implementation eveCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialViewLoad];

}


# pragma mark - Helper Methods
-(void) initialViewLoad{
    
    self.eventTableView.backgroundColor = [UIColor clearColor];
    self.eventTableView.separatorColor  = [UIColor clearColor];
    
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake(windowWidth-65, 0, 65, 45);
    //   self.nextButton.backgroundColor = [UIColor colorWithRed:(43.0/255.0) green:(48.0/255.0) blue:(60.0/255.0) alpha:1];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.nextButton setImage:[UIImage imageNamed:@"arrow_icon1"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.calenderView addSubview:self.nextButton];
    self.nextButton = self.nextButton;
    //self.calenderView.appearance.headerTitleFont = [AppUtility openSansSemiBoldFontWithSize:30];
    
    self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previousButton.frame = CGRectMake(0, 0, 75, 45);
    //  self.previousButton.backgroundColor = [UIColor colorWithRed:(43.0/255.0) green:(48.0/255.0) blue:(60.0/255.0) alpha:1];
    self.previousButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.previousButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [self.previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.calenderView addSubview:self.previousButton];
    self.previousButton = self.previousButton;
    
    self.calenderView.appearance.titleWeekendColor = [UIColor lightGrayColor];
    self.calenderView.appearance.eventDefaultColor = [UIColor greenColor];
    self.calenderView.appearance.eventDefaultColor = [UIColor colorWithRed:72.0/255.0 green:176.0/255.0 blue:254.0/255.0 alpha:1];
    self.calenderView.scrollEnabled = NO;
    
    [self.calenderView setScope:FSCalendarScopeMonth];
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentMonth = self.calenderView.currentPage;
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
    selectedMonthTimeStamp = [NSString stringWithFormat:@"%f",[currentMonth timeIntervalSince1970]];
    
    [self eventListLoadCall];

   

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Action

- (void)previousClicked:(id)sender {
    [self.view endEditing:YES];
    
    NSDate *currentMonth = self.calenderView.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calenderView setCurrentPage:previousMonth animated:YES];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    selectedMonthTimeStamp = [NSString stringWithFormat:@"%f",[previousMonth timeIntervalSince1970]];
    [self eventListLoadCall];

}

- (void)nextClicked:(id)sender {
    [self.view endEditing:YES];
    
    NSDate *currentMonth = self.calenderView.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calenderView setCurrentPage:nextMonth animated:YES];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    selectedMonthTimeStamp = [NSString stringWithFormat:@"%f",[nextMonth timeIntervalSince1970]];
    [self eventListLoadCall];
    
    
//    NSString *dateStr = @"2014-07-15";
//    NSDateFormatter *formatterDateStr=[[NSDateFormatter alloc]init];
//    [formatterDateStr setDateFormat:@"yyyy-MM-dd"];
//    NSDate *dsdsdf = [formatterDateStr dateFromString:dateStr];
//    [self.calenderView setCurrentPage:dsdsdf animated:YES];

    
    
 
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    selectedDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    [self getAllEventsForSelectedDate];
    
    
}





- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate* )date {
    
    BOOL shouldShowEventDot = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (int i= 0 ; i<eventDisplayOnCalendarArray.count; i++) {
        NSString *str_calendarDate = [dateFormatter stringFromDate:date];
        
        if ([[eventDisplayOnCalendarArray objectAtIndex:i] isEqualToString:str_calendarDate]) {
            shouldShowEventDot =YES;
        }
    }
    
    return shouldShowEventDot;
}

-(void) getAllEventsForSelectedDate {
    eventArrayTableView = [[NSMutableArray alloc]init];
    for (int count = 0; count < [eventDetailArray count]; count ++) {
        objModelEvent = [eventDetailArray objectAtIndex:count];
        if ([objModelEvent.eventStartDateModified isEqualToString:selectedDate]) {
            [eventArrayTableView addObject:objModelEvent];
        }else{
            start = objModelEvent.eventStartDateModified;
            end = objModelEvent.eventEndDateModified;
            [self addDatesForEventsForTableLoad];

        }
    }
           [self.eventTableView reloadData];
}


-(void)addDatesForEventsForTableLoad{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [formatter dateFromString:start];
    NSDate *endDate = [formatter dateFromString:end];
    
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
            if ([selectedDate isEqualToString:stringFromDate]) {
                [eventArrayTableView addObject:objModelEvent];
                break;
            }
            startDate = [myDateFormatter dateFromString:stringFromDate];
        }
    }
}



#pragma mark - UIAction methods

- (IBAction)backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Service Implemention

-(void)eventListLoadCall {
    
    eventDetailArray = [[NSMutableArray alloc]init];
    eventDisplayOnCalendarArray = [[NSMutableArray alloc]init];

    
    NSMutableDictionary *loginInfoDict = [NSMutableDictionary new];
    [loginInfoDict setValue:@"71" forKey:pUserID];
    [loginInfoDict setValue:@"month" forKey:@"calendarType"];
    [loginInfoDict setValue:selectedMonthTimeStamp forKey:@"timestamp"];
    [loginInfoDict setValue:@"28.5223" forKey:@"latitude"];
    [loginInfoDict setValue:@"77.2849" forKey:@"longitude"];

    
    [self apiCallForLoginAuthentication:loginInfoDict andServiceName:eventCalendar];
}

-(void)apiCallForLoginAuthentication:(NSMutableDictionary *)loginDetailDictonary andServiceName:(NSString *)serviceName {
    
    [[ServiceHelper sharedServiceHelper] callApiWithParameter:loginDetailDictonary apiName:serviceName andApiType:POST andIsRequiredHud:YES WithComptionBlock:^(NSDictionary *result, NSError *error) {
        
        if (!error) {
            //Success and 200 responseCode
            for (NSDictionary *dict in [result objectForKeyNotNull:@"events" expectedObj:[NSArray array]])
            {
                [eventDetailArray addObject:[EventCalendarModel eventDetails:dict]];
                EventCalendarModel *objModel = [EventCalendarModel eventDetails:dict];
                start = objModel.eventStartDateModified;
                end = objModel.eventEndDateModified;
                [eventDisplayOnCalendarArray addObject:objModel.eventStartDateModified];
                [self addDatesForEventsOnCalendar];
            }
            
            NSLog(@"date array=====%@",eventDisplayOnCalendarArray);
                [self.calenderView reloadData];
            
        }else if (error.code == 100) {
            //Success but other than 200 responseCode
            NSString *errorMessage = [result objectForKeyNotNull:pResponseMessage expectedObj:[NSString string]];
            [RequestTimeOutView showWithMessage:errorMessage forTime:2.0];
        }else {
            //Error
            NSString *errorMessage = [result objectForKeyNotNull:pResponseMessage expectedObj:[NSString string]];
            [RequestTimeOutView showWithMessage:errorMessage forTime:2.0];
        }
    }];
}

-(void)addDatesForEventsOnCalendar{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [formatter dateFromString:start];
    NSDate *endDate = [formatter dateFromString:end];
    
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
            [eventDisplayOnCalendarArray addObject:stringFromDate];
            startDate = [myDateFormatter dateFromString:stringFromDate];
        }
    }
}





# pragma mark - UITableview delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return eventArrayTableView.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    eveCalendarCell *cell =  [self.eventTableView dequeueReusableCellWithIdentifier:@"eveCalendarCell" forIndexPath:indexPath];
    
    EventCalendarModel *objModel = [eventArrayTableView objectAtIndex:indexPath.row];
    
    cell.eventTitleLabel.text = objModel.eventTitle;
    
    
    
    return cell;
}


@end
