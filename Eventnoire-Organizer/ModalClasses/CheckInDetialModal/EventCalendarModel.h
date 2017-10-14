//
//  EventCalendarModel.h
//  Eventnoire-Organizer
//
//  Created by Ashish Kumar Gupta on 11/05/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventCalendarModel : NSObject

@property(nonatomic,strong)NSString *eventEndDate;
@property(nonatomic,strong)NSString *eventStartDate;
@property(nonatomic,strong)NSString *eventTitle;
@property(nonatomic,strong)NSString *eventImageUrl;
@property(nonatomic,strong)NSString *eventId;

@property(nonatomic,strong)NSString *eventVenueName;
@property(nonatomic,strong)NSString *eventDescription;
@property(nonatomic,strong)NSString *eventDistance;
@property(nonatomic,strong)NSString *eventLatitude;
@property(nonatomic,strong)NSString *eventLongitude;
@property(nonatomic,strong)NSString *eventStartTimeModified;
@property(nonatomic,strong)NSString *eventEndTimeModified;
@property(nonatomic,strong)NSString *eventStartDateModified;
@property(nonatomic,strong)NSString *eventEndDateModified;
@property(nonatomic,strong)NSString *eventDistanceIn;

@property(nonatomic,assign) BOOL isMoreNeeded;

// Event Calendar
+(EventCalendarModel*) eventDetails:(NSDictionary*)dict;

// Dash Board
+(EventCalendarModel*) eventNameDetails:(NSDictionary*)dict;

// Event Detail
+(EventCalendarModel*) eventInfoDetails:(NSDictionary*)dict;

@end
