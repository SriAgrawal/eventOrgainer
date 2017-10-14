//
//  DashboardModal.h
//  Eventnoire-Organizer
//
//  Created by Abhishek Agarwal on 18/05/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DashboardModal : NSObject

@property (strong, nonatomic) NSString *totalAttendance;
@property (strong, nonatomic) NSString *totalAttendies;
@property (strong, nonatomic) NSString *totalCheckins;
@property (strong, nonatomic) NSString *totalSell;

+(DashboardModal *)parseDashboardModal :(NSDictionary *)dashboardDict;

@end
