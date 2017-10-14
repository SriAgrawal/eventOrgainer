//  PushNotificationVC.m
//  Eventnoire-Attendee
//  Created by Aiman Akhtar on 04/04/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.

#import "NSDictionary+NullChecker.h"
#import "RequestTimeOutView.h"
#import "PushNotificationVC.h"
#import "ServiceHelper.h"
#import "Macro.h"

@interface PushNotificationVC ()

@property (weak, nonatomic) IBOutlet UISwitch *announcementSwitch;

@end

@implementation PushNotificationVC

#pragma mark - UIViewController life cycle & memory management

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton action Methods

- (void) initialSetup {
    
    NSDictionary *userDetail = [NSUSERDEFAULT valueForKey:pUserDetail];
    BOOL announcementStatus = [[userDetail objectForKeyNotNull:pIsAnouncement expectedObj:[NSString string]] boolValue];
    
    [self.announcementSwitch setOn:announcementStatus];
}

#pragma mark - UIButton action Methods

- (IBAction)announcementSwitchButtonAction:(UISwitch *)sender {
    [self statusOfAnnouncement:sender.on];
}

- (IBAction)backButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Service Implemention

-(void)statusOfAnnouncement:(BOOL)status {
    
    NSMutableDictionary *announementStatusDict = [NSMutableDictionary new];
    [announementStatusDict setValue:[NSString stringWithFormat:@"%d",status] forKey:pIsAnouncement];
    
    [self apiCallForchangeNotificationStatus:announementStatusDict andServiceName:updateNotificationApi];
}

-(void)apiCallForchangeNotificationStatus:(NSMutableDictionary *)announcementDict andServiceName:(NSString *)serviceName {
	
	NSLog(@"testing");
	
	
    [[ServiceHelper sharedServiceHelper] callApiWithParameter:announcementDict apiName:serviceName andApiType:POST andIsRequiredHud:NO WithComptionBlock:^(NSDictionary *result, NSError *error) {
        
        if (!error) {
            //Success and 200 responseCode
            NSMutableDictionary *userDetailDict = [[NSUSERDEFAULT valueForKey:pUserDetail] mutableCopy];
            [NSUSERDEFAULT removeObjectForKey:pUserDetail];
            
            [userDetailDict setValue:[result objectForKeyNotNull:pIsAnouncement expectedObj:[NSString string]] forKey:pIsAnouncement];
            
            [NSUSERDEFAULT setValue:userDetailDict forKey:pUserDetail];
            
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
