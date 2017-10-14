//
//  CheckInDetailModal.m
//  Eventnoire-Organizer
//
//  Created by Abhishek Agarwal on 06/05/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import "CheckInDetailModal.h"
#import "NSDictionary+NullChecker.h"
#import "Macro.h"

@implementation CheckInDetailModal

+(CheckInDetailModal *)parseCheckListDetail:(NSDictionary *)listDictionary {
    CheckInDetailModal *checkInModal = [CheckInDetailModal new];
    
    //checkInModal.checkInItemID = [listDictionary objectForKeyNotNull:pID expectedObj:[NSString string]];
    checkInModal.bookID = [listDictionary objectForKeyNotNull:pBookID expectedObj:[NSString string]];
    checkInModal.eventName = [listDictionary objectForKeyNotNull:pEventName expectedObj:[NSString string]];
    checkInModal.totalAmountInUSD = [listDictionary objectForKeyNotNull:pTotalAmount expectedObj:[NSString string]];
    checkInModal.amountCurrency = [listDictionary objectForKeyNotNull:pAmountCurrency expectedObj:[NSString string]];

    checkInModal.registrationQuantity = [listDictionary objectForKeyNotNull:pEventRegistrationQuantity expectedObj:[NSString string]];
    checkInModal.codeScannerImageURL = [listDictionary objectForKeyNotNull:pCodeScannerImage expectedObj:[NSString string]];
    checkInModal.eventTicketID = [listDictionary objectForKeyNotNull:pEventTicketID expectedObj:[NSString string]];

    checkInModal.eventStartDateTimeStamp = [listDictionary objectForKeyNotNull:pEventStartDate expectedObj:[NSString string]];
    checkInModal.eventEndDateTimeStamp = [listDictionary objectForKeyNotNull:pEventEndDate expectedObj:[NSString string]];

    checkInModal.registrationDateTimeStamp = [listDictionary objectForKeyNotNull:pRegistrationDate expectedObj:[NSString string]];

    [checkInModal getRegistrationDateAndEventDateTime];
    
    return checkInModal;
}

-(void)getRegistrationDateAndEventDateTime {
    
    NSDate * startDate = [NSDate dateWithTimeIntervalSince1970:[self.eventStartDateTimeStamp integerValue]];
    //NSDate * endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[self.eventEndDateTimeStamp integerValue]];
    
    NSDate * registrationDate = [NSDate dateWithTimeIntervalSince1970:[self.registrationDateTimeStamp integerValue]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    self.registrationDateString = [dateFormatter stringFromDate:registrationDate];
    
    NSString *startDateString = [dateFormatter stringFromDate:startDate];
    
    [dateFormatter setDateFormat:@"hh:mm a"];

    NSString *startTime = [dateFormatter stringFromDate:startDate];
    
    self.eventStartDateString = [NSString stringWithFormat:@"%@, %@",startDateString,startTime];
}

@end
