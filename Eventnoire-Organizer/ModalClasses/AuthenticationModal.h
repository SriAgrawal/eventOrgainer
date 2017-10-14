//
//  LoginModal.h
//  Eventnoire-Organizer
//
//  Created by Abhishek Agarwal on 04/05/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationModal : NSObject

//Normal Login
@property (strong, nonatomic) NSString   *email;
@property (strong, nonatomic) NSString   *password;

//Social Login
@property (strong, nonatomic) NSString   *socialID;
@property (strong, nonatomic) NSString   *socialType;
@property (strong, nonatomic) NSString   *profilePicture;
@property (strong, nonatomic) NSString   *userName;

//SignUP
@property (strong, nonatomic) NSString   *firstName;
@property (strong, nonatomic) NSString   *lastName;
@property (strong, nonatomic) NSString   *phoneNumber;
@property (strong, nonatomic) NSString   *errorMessage;
@property (strong, nonatomic) NSString   *countryCode;
@property (strong, nonatomic) NSString   *countryCodeAndName;

@property (assign, nonatomic) NSInteger index;

//ChangePassword
@property (strong, nonatomic) NSString   *selectedPassword; //New Password
@property (strong, nonatomic) NSString   *confirmPassword;


//OTP
@property (strong, nonatomic) NSString   *otp;

@end
