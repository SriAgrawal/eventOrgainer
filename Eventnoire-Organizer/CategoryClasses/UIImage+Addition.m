//
//  UIImage+Addition.m
//  VoiceSociety
//
//  Created by Raj Kumar Sharma on 04/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Addition)

- (NSString *)getBase64String {
    
    NSData *imageData = UIImageJPEGRepresentation(self ,1.0);
    
    return [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

- (NSString *)getBase64StringWithQuality:(CGFloat)value {
    
    NSData *imageData = UIImageJPEGRepresentation(self ,value);
    
    return [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

@end
