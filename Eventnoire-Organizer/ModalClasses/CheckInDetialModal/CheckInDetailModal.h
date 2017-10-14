//
//  CheckInDetailModal.h
//  Eventnoire-Organizer
//
//  Created by Abhishek Agarwal on 06/05/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckInDetailModal : NSObject

@property (strong, nonatomic) NSString   *checkInItemID;
@property (strong, nonatomic) NSString   *bookID;
@property (strong, nonatomic) NSString   *eventName;
@property (strong, nonatomic) NSString   *registrationDateTimeStamp;
@property (strong, nonatomic) NSString   *totalAmountInUSD;
@property (strong, nonatomic) NSString   *amountCurrency;
@property (strong, nonatomic) NSString   *eventStartDateTimeStamp;
@property (strong, nonatomic) NSString   *eventEndDateTimeStamp;
@property (strong, nonatomic) NSString   *registrationQuantity;
@property (strong, nonatomic) NSString   *codeScannerImageURL;
@property (strong, nonatomic) NSString   *eventTicketID;

@property (strong, nonatomic) NSString   *registrationDateString;
@property (strong, nonatomic) NSString   *eventStartDateString;

+(CheckInDetailModal *)parseCheckListDetail:(NSDictionary *)listDictionary;

@end
