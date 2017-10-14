//
//  EventCalendarModel.m
//  Eventnoire-Organizer
//
//  Created by Ashish Kumar Gupta on 11/05/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import "NSDictionary+NullChecker.h"
#import "EventCalendarModel.h"
#import "AppUtility.h"

@implementation EventCalendarModel
+(EventCalendarModel*) eventDetails:(NSDictionary*)dict{
    
    EventCalendarModel *objInfo = [[EventCalendarModel alloc] init];
    objInfo.eventId  = [dict objectForKeyNotNull:@"id" expectedObj:@""];
    objInfo.eventTitle  = [dict objectForKeyNotNull:@"title" expectedObj:@""];
    objInfo.eventImageUrl  = [dict objectForKeyNotNull:@"image_url" expectedObj:@""];
    objInfo.eventStartDate  = [dict objectForKeyNotNull:@"start_date" expectedObj:@""];
    objInfo.eventEndDate  = [dict objectForKeyNotNull:@"end_date" expectedObj:@""];
    
   objInfo.eventStartDateModified = [AppUtility convertDateToString:[objInfo.eventStartDate integerValue] andDateFormat:@"yyyy-MM-dd"];
    objInfo.eventEndDateModified = [AppUtility convertDateToString:[objInfo.eventEndDate integerValue] andDateFormat:@"yyyy-MM-dd"];
    
    return objInfo;
}

//Dashboard 
+(EventCalendarModel*) eventNameDetails:(NSDictionary*)dict{
    EventCalendarModel *objInfo = [[EventCalendarModel alloc] init];
    objInfo.eventId  = [dict objectForKeyNotNull:@"eventId" expectedObj:@""];
    objInfo.eventTitle  = [dict objectForKeyNotNull:@"eventTitle" expectedObj:@""];
    objInfo.eventStartDate  = [dict objectForKeyNotNull:@"eventStartDate" expectedObj:@""];
    objInfo.eventEndDate  = [dict objectForKeyNotNull:@"eventEndDate" expectedObj:@""];
    
    objInfo.eventStartDateModified = [AppUtility convertDateToString:[objInfo.eventStartDate integerValue] andDateFormat:@"yyyy-MM-dd"];
     objInfo.eventEndDateModified = [AppUtility convertDateToString:[objInfo.eventEndDate integerValue] andDateFormat:@"yyyy-MM-dd"];

    return objInfo;
}

// Event Detail
+(EventCalendarModel*) eventInfoDetails:(NSDictionary*)dict{
    
    EventCalendarModel *objModel = [[EventCalendarModel alloc]init];
    objModel.eventVenueName  = [dict objectForKeyNotNull:@"venue_name" expectedObj:@""];
    objModel.eventTitle  = [dict objectForKeyNotNull:@"title" expectedObj:@""];
    objModel.eventStartDate  = [dict objectForKeyNotNull:@"start_date" expectedObj:@""];
    objModel.eventEndDate  = [dict objectForKeyNotNull:@"end_date" expectedObj:@""];
    objModel.eventDescription  = [dict objectForKeyNotNull:@"description" expectedObj:@""];
    objModel.eventDistance  = [NSString stringWithFormat:@"%.2f",[[dict objectForKeyNotNull:@"distance" expectedObj:@"0"] floatValue]];
    objModel.eventLatitude  = [dict objectForKeyNotNull:@"latitude" expectedObj:@""];
    objModel.eventLongitude  = [dict objectForKeyNotNull:@"longitude" expectedObj:@""];
    objModel.eventImageUrl  = [dict objectForKeyNotNull:@"image_url" expectedObj:@""];
    objModel.eventDistanceIn  = [dict objectForKeyNotNull:@"distance_in" expectedObj:@""];

    objModel.eventStartDateModified = [AppUtility convertDateToString:[objModel.eventStartDate integerValue] andDateFormat:@"EEE MMMM dd"];
    objModel.eventStartTimeModified = [AppUtility convertDateToString:[objModel.eventStartDate integerValue] andDateFormat:@"hh:mm a"];
    
    objModel.eventEndDateModified = [AppUtility convertDateToString:[objModel.eventEndDate integerValue] andDateFormat:@"EEE MMMM dd"];
     objModel.eventEndTimeModified = [AppUtility convertDateToString:[objModel.eventEndDate integerValue] andDateFormat:@"hh:mm a"];
    
    NSInteger textHeight = [AppUtility getHeightFromText: objModel.eventDescription];
    
    if (textHeight > 75) {
        objModel.isMoreNeeded = YES;
    }else
        objModel.isMoreNeeded = NO;
    
    return objModel;
}

@end
