//
//  DashboardModal.m
//  Eventnoire-Organizer
//
//  Created by Abhishek Agarwal on 18/05/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import "NSDictionary+NullChecker.h"
#import "DashboardModal.h"
#import "Macro.h"

@implementation DashboardModal

+(DashboardModal *)parseDashboardModal :(NSDictionary *)dashboardDict {
    
    DashboardModal *dashboard = [DashboardModal new];
    
    dashboard.totalAttendance = [dashboardDict objectForKeyNotNull:pTotalAttendance expectedObj:[NSString string]];
    dashboard.totalAttendies = [dashboardDict objectForKeyNotNull:pTotalAttendies expectedObj:[NSString string]];
    dashboard.totalCheckins = [dashboardDict objectForKeyNotNull:pTotalCheckIns expectedObj:[NSString string]];
    dashboard.totalSell = [dashboardDict objectForKeyNotNull:pTotalSell expectedObj:[NSString string]];

    return dashboard;
}

@end
