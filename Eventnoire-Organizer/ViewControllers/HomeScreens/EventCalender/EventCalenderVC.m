//
//  EventCalenderVC.m
//  Eventnoire-Organizer
//
//  Created by Aiman Akhtar on 10/04/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//
#import "UITableView+SetIndicatorAndLabelInMiddle.h"
#import "UIImageView+WebCache.h"
#import "NSDictionary+NullChecker.h"
#import "OptionsPickerSheetView.h"
#import "EventCalendarCell.h"
#import "EventCalendarModel.h"
#import "RequestTimeOutView.h"
#import "EventCalenderVC.h"
#import "AppUtility.h"
#import "AppDelegate.h"
#import "ServiceHelper.h"
#import "FSCalendar.h"
#import "InfoVC.h"
#import "Macro.h"

@interface EventCalenderVC ()<FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *eventDetailArray;
    NSMutableArray *eventDisplayOnCalendarArray;
    NSMutableArray *eventArrayTableView;
    
    NSString *start;
    NSString *end;
    
    NSString *selectedDate;
    NSString *selectedMonth;
}

@property (strong, nonatomic) IBOutlet FSCalendar *calenderView;
@property(nonatomic,retain)IBOutlet UITableView *eventTableView;

@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;
@property (weak, nonatomic)IBOutlet UIButton *selectMonthButton;
@property (weak, nonatomic)IBOutlet UIButton *selectYearButton;

@property (strong, nonatomic) NSCalendar *gregorian;

@property (weak, nonatomic) IBOutlet UILabel *emptyTextLabel;

@end

@implementation EventCalenderVC

#pragma mark - UIViewController Life cycle & Memory Management

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialViewLoad];
}

# pragma mark - Helper Methods

-(void) initialViewLoad {
    
    self.eventTableView.backgroundColor = [UIColor clearColor];
    self.eventTableView.separatorColor  = [UIColor clearColor];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake(windowWidth-65, 0, 65, 45);
    self.nextButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    [self.nextButton setImage:[UIImage imageNamed:@"arrow_icon1"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.calenderView addSubview:self.nextButton];
    [self.nextButton bringSubviewToFront:self.calenderView];
    
    self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previousButton.frame = CGRectMake(0, 0, 75, 45);
    self.previousButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    [self.previousButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [self.previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.calenderView addSubview:self.previousButton];
    
    self.calenderView.appearance.titleWeekendColor = [UIColor lightGrayColor];
    self.calenderView.appearance.eventDefaultColor = [UIColor greenColor];
    self.calenderView.appearance.eventDefaultColor = [UIColor colorWithRed:72.0/255.0 green:176.0/255.0 blue:254.0/255.0 alpha:1];
    self.calenderView.scrollEnabled = NO;
    
    [self.calenderView setScope:FSCalendarScopeMonth];
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentMonth = self.calenderView.currentPage;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *selectedMonthTimeStamp = [NSString stringWithFormat:@"%f",[currentMonth timeIntervalSince1970]];
    
    eventDetailArray = [[NSMutableArray alloc]init];
    eventDisplayOnCalendarArray = [[NSMutableArray alloc]init];
    eventArrayTableView = [[NSMutableArray alloc]init];

    [self.emptyTextLabel setHidden:YES];
    
    [self eventListLoadCall:selectedMonthTimeStamp];
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
    NSString *selectedMonthTimeStamp = [NSString stringWithFormat:@"%f",[previousMonth timeIntervalSince1970]];
    
    [self eventListLoadCall:selectedMonthTimeStamp];
}

- (void)nextClicked:(id)sender {
    [self.view endEditing:YES];
    
    NSDate *currentMonth = self.calenderView.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calenderView setCurrentPage:nextMonth animated:YES];
    
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *selectedMonthTimeStamp = [NSString stringWithFormat:@"%f",[nextMonth timeIntervalSince1970]];
    
    [self eventListLoadCall:selectedMonthTimeStamp];
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
    
    [eventArrayTableView removeAllObjects];
    
    for (int count = 0; count < [eventDetailArray count]; count ++) {
        EventCalendarModel *objModelEvent = [eventDetailArray objectAtIndex:count];
        
        if ([objModelEvent.eventStartDateModified isEqualToString:selectedDate]) {
            [eventArrayTableView addObject:objModelEvent];
        }else{
            start = objModelEvent.eventStartDateModified;
            end = objModelEvent.eventEndDateModified;
            [self addDatesForEventsForTableLoad:objModelEvent];
            
        }
    }
    
    if ([eventArrayTableView count]) {
        [self.emptyTextLabel setHidden:YES];
    }else {
        [self.emptyTextLabel setHidden:NO];
    }
    
    [self.eventTableView reloadData];
}

-(void)addDatesForEventsForTableLoad:( EventCalendarModel *)eventModal {
    
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
                [eventArrayTableView addObject:eventModal];
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

- (IBAction)selectMonthAction:(UIButton *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSString *monthString = [formatter stringFromDate:[NSDate date]];
    
   NSArray *monthArray = [[NSArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    NSArray *monthIdArray = [[NSArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];

    [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:monthArray andCurrentSelectionIndex:[monthArray indexOfObject:monthString] AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
        [self.selectMonthButton setTitle:selectedText forState:UIControlStateNormal];
        selectedMonth = [monthIdArray objectAtIndex:selectedIndex];
    }];
}

- (IBAction)selectYearAction:(UIButton *)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    NSMutableArray *yearArray = [NSMutableArray array];
    for (int year = 2000; year <= [yearString integerValue]+5; year++) {
        [yearArray addObject:[NSString stringWithFormat:@"%i",year]];
    }

    [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:[yearArray mutableCopy] andCurrentSelectionIndex:[yearArray indexOfObject:yearString]  AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
        [self.selectYearButton setTitle:selectedText forState:UIControlStateNormal];
    }];
}

- (IBAction)applyAction:(UIButton *)sender {
    
    if ([self.selectMonthButton.titleLabel.text isEqualToString:@"Month"] ) {
        [RequestTimeOutView showWithMessage:@"*Please select month." forTime:2.0];
    }else if ([self.selectYearButton.titleLabel.text isEqualToString:@"Year"]){
        [RequestTimeOutView showWithMessage:@"*Please select year." forTime:2.0];
    }else{
        [eventArrayTableView removeAllObjects];
        [eventDisplayOnCalendarArray removeAllObjects];

        NSString *combinedDate = [[[[self.selectYearButton.titleLabel.text stringByAppendingString:@"-"]stringByAppendingString:selectedMonth]stringByAppendingString:@"-"]stringByAppendingString:@"01"];
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *selectedMonthValue = [formatter dateFromString:combinedDate];
        [self.calenderView setCurrentPage:selectedMonthValue animated:YES];
        
        NSString *selectedMonthTimeStamp = [NSString stringWithFormat:@"%f",[selectedMonthValue timeIntervalSince1970]];
        
        [self eventListLoadCall:selectedMonthTimeStamp];
    }
}

#pragma mark - Service Implemention

-(void)eventListLoadCall:(NSString *)selectMonthTimeStamp {
    
    [eventDetailArray removeAllObjects];
    [eventDisplayOnCalendarArray removeAllObjects];
    
    NSMutableDictionary *eventListDict = [NSMutableDictionary new];
    
    [eventListDict setValue:@"month" forKey:@"calendarType"];
    [eventListDict setValue:selectMonthTimeStamp forKey:@"timestamp"];
    
    if ([APPDELEGATE location]) {
        [eventListDict setValue:[NSString stringWithFormat:@"%f",[APPDELEGATE location].coordinate.latitude] forKey:pLatitude];
        [eventListDict setValue:[NSString stringWithFormat:@"%f",[APPDELEGATE location].coordinate.latitude] forKey:pLongitude];
    }
    
    [self apiCallForGettingMonthEvent:eventListDict andServiceName:eventCalendar];
}

-(void)apiCallForGettingMonthEvent:(NSMutableDictionary *)request andServiceName:(NSString *)serviceName {
    
    [[ServiceHelper sharedServiceHelper] callApiWithParameter:request apiName:serviceName andApiType:POST andIsRequiredHud:YES WithComptionBlock:^(NSDictionary *result, NSError *error) {
        
        if (!error) {
            //Success and 200 responseCode
            
            NSArray *eventArray = [result objectForKeyNotNull:@"events" expectedObj:[NSArray array]];
            
            for (NSDictionary *dict in eventArray)
            {
                EventCalendarModel *eventModal = [EventCalendarModel eventDetails:dict];
                [eventDetailArray addObject:eventModal];
                
                start = eventModal.eventStartDateModified;
                end = eventModal.eventEndDateModified;
                [eventDisplayOnCalendarArray addObject:eventModal.eventStartDateModified];
                
                [self addDatesForEventsOnCalendar];
            }
            
            if ([eventArrayTableView count]) {
                [self.emptyTextLabel setHidden:YES];
            }else {
                [self.emptyTextLabel setHidden:NO];
            }
            
            [self.calenderView reloadData];
            
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

-(void)addDatesForEventsOnCalendar {
    
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
    return [eventArrayTableView count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventCalendarCell *cell =  [self.eventTableView dequeueReusableCellWithIdentifier:@"EventCalendarCell" forIndexPath:indexPath];
    
    EventCalendarModel *objModel = [eventArrayTableView objectAtIndex:indexPath.row];
    
    cell.eventTitleLabel.text = objModel.eventTitle;
    cell.eventImage.clipsToBounds = YES;
    
    [cell.eventImage sd_setImageWithURL:[NSURL URLWithString:objModel.eventImageUrl] placeholderImage:[UIImage imageNamed:@"eventPlaceholder"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{
    
    EventCalendarModel *objModel = [eventArrayTableView objectAtIndex:indexPat.row];

    InfoVC *infoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoVC"];
    infoVC.selectedEventId = objModel.eventId;
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
