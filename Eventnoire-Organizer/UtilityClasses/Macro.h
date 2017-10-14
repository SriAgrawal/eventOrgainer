//
//  Macro.h
//  Eventnoire-Attendee
//
//  Created by Aiman Akhtar on 23/03/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//Find Object by tag
#define TextField(tag)             (UITextField*)[self.view viewWithTag:tag]
#define TextView(tag)              (UITextView*)[self.view viewWithTag:tag]
#define Button(tag)                (UIButton *)[self.view viewWithTag:tag]

//Screen width and Height
#define windowWidth                 [UIScreen mainScreen].bounds.size.width
#define windowHeight                [UIScreen mainScreen].bounds.size.height

//Localisation
#define KNSLOCALIZEDSTRING(key)     NSLocalizedString(key, nil)

//Utility
#define APPDELEGATE                 (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define TRIM_SPACE(str)                 [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define NSUSERDEFAULT               [NSUserDefaults standardUserDefaults]

//Storyboard
#define mainStoryboard              [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define storyboardForName(X)        [UIStoryboard storyboardWithName:X bundle:nil]

//log label
#define LOG_LEVEL           1

#define LogInfo(frmt, ...)                 if(LOG_LEVEL) NSLog((@"%s" frmt), __PRETTY_FUNCTION__, ## __VA_ARGS__);

//Set Color and Font
#define RGBCOLOR(r,g,b,a)               [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define AppColor                    [UIColor colorWithRed:72.0/255.0f green:176.0/255.0f blue:254.0/255.0f alpha:1.0f]
#define AppFont(X)                  [UIFont fontWithName:@"OpenSans" size:X]

//Device Check
#define SCREEN_MAX_LENGTH (MAX(windowWidth, windowHeight))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_OS_8_OR_LATER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//Key
#define GoogleClientID    @"212074973112-r8ouqr28gjagtpmefjdg1m9gff0qbr89.apps.googleusercontent.com"
#define GoogleKey    @"AIzaSyDzCmPLTZLKlLRxvCMFqO8S63wGKaGhE-g"


//Validation
static NSString *blank_Name                       = @"*Please enter name.";
static NSString *blank_FirstName                  = @"*Please enter first name.";
static NSString *blank_LastName                   = @"*Please enter last name.";
static NSString *blank_Email                      = @"*Please enter email.";
static NSString *blank_Password                   = @"*Please enter password.";
static NSString *blank_Phone                      = @"*Please enter phone number.";
static NSString *blank_Confirm_Password           = @"*Please enter confirm password.";
static NSString *blank_OTP                        = @"*Please enter OTP.";
static NSString *blank_Email_Mobile               = @"*Please enter email/mobile no.";
static NSString *blank_Event                      = @"*Please select event type.";
static NSString *blank_Search_Event               = @"*Please enter event location.";
static NSString *blank_Event_Date                 = @"*Please select event date.";
static NSString *blank_Event_Time                 = @"*Please select event time.";
static NSString *blank_Event_Detail               = @"*Please enter event detail.";
static NSString *blank_CountryCode                      = @"*Please select country code.";

static NSString *valid_Email                      = @"*Please enter a valid email.";
static NSString *valid_FirstName                  = @"*Please enter a valid first name.";
static NSString *valid_Otp                        = @"*Please enter valid otp.";
static NSString *valid_Phone                      = @"*Please enter a valid phone number";
static NSString *valid_Password                   = @"*Password must be of atleast 8 characters.";
static NSString *password_Confirm_Password_Not_Match = @"*Please enter correct password.";
static NSString *valid_MobileNumber               = @"*Phone number must be of 10 digits.";

static NSString *new_Password                     = @"*Please enter new password.";
static NSString *valid_New_Password               = @"*New password must be of atleast 8 characters.";
static NSString *no_event                = @"*No event found.";
static NSString *no_event_selected                = @"*Please select event first.";




//Service Name
static NSString *loginApi                         = @"login";
static NSString *signUpApi                        = @"signup";
static NSString *forgotPasswordApi                = @"forgot_password";
static NSString *verifyOTPApi                       = @"verify_otp";
static NSString *resendOTPApi                     = @"send_otp";
static NSString *socialLoginApi                   = @"social_login";
static NSString *infoPagesApi                     = @"static_content";
static NSString *pushSettingApi                   = @"pushSetting";
static NSString *logoutApi                              = @"logout";
static NSString *updateNotificationApi            = @"update_settings";
static NSString *checkInDataApi                     = @"event_check_in";
static NSString *changePasswordApi                     = @"change_password";
static NSString *eventCalendar                    = @"events_calendar";
static NSString *eventListOrganizerApi                    = @"organizer_event_list";
static NSString *dashBoardAPI                    = @"organizer_dashboard";
static NSString *resetPassswordAPI                    = @"reset_password";
static NSString *scanVerificationAPI                    = @"book_event_scan";
static NSString *eventListApi            = @"events_list";




//API Keys
static NSString *pResponseCode                    = @"response_code";
static NSString *pResponseMessage               = @"message";
static NSString *pDeviceType                      = @"deviceType";
static NSString *pDeviceToken                     = @"deviceToken";
static NSString *pUserType                        = @"userType";
static NSString *pUserID                          = @"userId";
static NSString *pEmailID                         = @"email";
static NSString *pPassword                        = @"password";
static NSString *pUserDetail                      = @"data";
static NSString *pPhoneNumber                     = @"phoneNumber";
static NSString *pFirstName                       = @"firstName";
static NSString *pProfilePic                      = @"profilePicture";
static NSString *pLastName                        = @"lastName";
static NSString *pIsPhoneNumberVerify            = @"isPhoneNumberVerify";
static NSString *pIsAnouncement                     = @"isAnouncement";
static NSString *pIsFriendUpdate                     = @"isFriendUpdate";
static NSString *pOTPNumber                          = @"otpNumber";
static NSString *pSocialID                                = @"socialID";
static NSString *pContentType                         = @"contentType";
static NSString *pContent                                = @"content";
static NSString *pSocialType                            = @"socialType";
static NSString *pUserName                             = @"userName";
static NSString *pToken                                   = @"token";
static NSString *iSTutorialSeen                         = @"iSTutorialSeen";
static NSString *pBookID                                   = @"event_id";
static NSString *pEventName                            = @"title";
static NSString *pID                                           = @"id";
static NSString *pCheckInDetail                          = @"check_in_data";
static NSString *pRegistrationDate                    = @"registration_date";
static NSString *pTotalAmount                          = @"ticket_amount";
static NSString *pEventDate                             = @"eventDate";
static NSString *pEventRegistrationQuantity      = @"ticket_quantity";
static NSString *pCodeScannerImage                = @"qr_code_url";
static NSString *pNewPassword                     = @"newPassword";
static NSString *pIsRemember                     = @"isRemember";
static NSString *pLoginInfo                     = @"loginInfo";
static NSString *pAuthorization                                     = @"Authorization";
static NSString *pEventID                                     = @"eventId";
static NSString *pOTP                                     = @"otp";
static NSString *pVerificationEventId                                    = @"event_id";
static NSString *pVerificationTicketId                    = @"event_ticket_id";
static NSString *pVerificationQrcode                                   = @"qr_code";
static NSString *pEvents                                    = @"events";
static NSString *pFbFriendList              = @"facebook_friend_id";
static NSString *pEventTicketID              = @"event_ticket_id";
static NSString *pEventStartDate              = @"start_date";
static NSString *pEventEndDate              = @"end_date";
static NSString *pType                                           = @"type";
static NSString *pLatitude                                    = @"latitude";
static NSString *pLongitude                                    = @"longitude";
static NSString *pSearch_event                             = @"search_event";
static NSString *pInterest_id                            = @"category_id";
static NSString *pTotalAttendies                            = @"totalAttendies";
static NSString *pTotalCheckIns                            = @"totalCheckins";
static NSString *pTotalSell                            = @"totalSell";
static NSString *pTotalAttendance                            = @"totalAttendance";
static NSString *pAmountCurrency                            = @"currency";
static NSString *pPagination                            = @"pagination";
static NSString *pPageNumber                            = @"page_number";
static NSString *pMaximumPages                            = @"maximumPages";
static NSString *pTotalNumberOfRecords                            = @"total_no_records";
static NSString *pLogInType                            = @"socialType";




#endif /* Macro_h */
