//
//  UIDevice+SupportedDevices.h
//
//  Created by Arthur Sabintsev on 10/25/13.
//  Copyright (c) 2013 Arthur Ariel Sabintsev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SupportedDevices)

+ (NSString *)machineName;
+ (NSString *)simulatorNamePhone;
+ (NSString *)simulatorNamePad;
+ (NSString *)supportedDeviceName;

@end
