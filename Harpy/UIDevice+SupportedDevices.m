//
//  UIDevice+SupportedDevices.m
//
//  Created by Arthur Sabintsev on 10/25/13.
//  Copyright (c) 2013 Arthur Ariel Sabintsev. All rights reserved.
//

#import "UIDevice+SupportedDevices.h"
#import <sys/utsname.h>

@implementation UIDevice (SupportedDevices)

+ (NSString *)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)simulatorNamePhone
{
    return @"iPhone Simulator";
}

+ (NSString *)simulatorNamePad
{
    return @"iPad Simulator";
}

+ (NSString *)supportedDeviceName
{
    NSString *deviceName = nil;
    NSString *machineName = [self machineName];
    
    // Model information retrieved from http://theiphonewiki.com/wiki/Models
    if ([machineName isEqualToString:@"iPad1,1"]) deviceName = @"iPadWifi";                 // iPad 1G Wi-Fi/GSM (also iPad3g)
    else if ([machineName isEqualToString:@"iPad2,1"]) deviceName = @"iPad2Wifi";           // iPad 2 Wi-Fi
    else if ([machineName isEqualToString:@"iPad2,2"]) deviceName = @"iPad23G";             // iPad 2 GSM
    else if ([machineName isEqualToString:@"iPad2,3"]) deviceName = @"iPad23G";             // iPad 2 CDMA
    else if ([machineName isEqualToString:@"iPad2,4"]) deviceName = @"iPad2Wifi";           // iPad 2 Wi-Fi Rev A
    else if ([machineName isEqualToString:@"iPad3,1"]) deviceName = @"iPadThirdGen";        // iPad 3 Wi-Fi
    else if ([machineName isEqualToString:@"iPad3,2"]) deviceName = @"iPadThirdGen4G";      // iPad 3 GSM+CDMA
    else if ([machineName isEqualToString:@"iPad3,3"]) deviceName = @"iPadThirdGen4G";      // iPad 3 GSM
    else if ([machineName isEqualToString:@"iPad3,4"]) deviceName = @"iPadFourthGen";       // iPad 4 Wi-Fi
    else if ([machineName isEqualToString:@"iPad3,5"]) deviceName = @"iPadFourthGen4G";     // iPad 4 GSM
    else if ([machineName isEqualToString:@"iPad3,6"]) deviceName = @"iPadFourthGen4G";     // iPad 4 GSM+CDMA
    else if ([machineName isEqualToString:@"iPad4,1"]) deviceName = @"iPadFourthGen4G";     // iPad Air Wi-Fi (SAME AS iPAD 4)
    else if ([machineName isEqualToString:@"iPad4,2"]) deviceName = @"iPadFourthGen4G";     // iPad Air Cellular (SAME AS iPAD 4)
    else if ([machineName isEqualToString:@"iPad2,5"]) deviceName = @"iPadMini";            // iPad mini 1G Wi-Fi
    else if ([machineName isEqualToString:@"iPad2,6"]) deviceName = @"iPadMini4G";          // iPad mini 1G GSM
    else if ([machineName isEqualToString:@"iPad2,7"]) deviceName = @"iPadMini4G";          // iPad mini 1G GSM+CDMA
    else if ([machineName isEqualToString:@"iPad4,4"]) deviceName = @"iPadMini";            // iPad mini 2G Wi-Fi (SAME AS iPAD MINI 1)
    else if ([machineName isEqualToString:@"iPad4,5"]) deviceName = @"iPadMini";            // iPad mini 2G Cellular (SAM AS iPAD MINI 1)
    else if ([machineName isEqualToString:@"iPod1,1"]) deviceName = @"iPod-touch";          // iPod touch 1G
    else if ([machineName isEqualToString:@"iPod2,1"]) deviceName = @"iPod-touch-with-mic"; // iPod touch 2G
    else if ([machineName isEqualToString:@"iPod3,1"]) deviceName = @"iPodTouchThirdGen";   // iPod touch 3G
    else if ([machineName isEqualToString:@"iPod4,1"]) deviceName = @"iPodTouchourthGen";   // iPod touch 4G (Yes, it's 'ourthGen')
    else if ([machineName isEqualToString:@"iPod5,1"]) deviceName = @"iPodTouchFifthGen";   // iPod touch 5G
    else if ([machineName isEqualToString:@"iPhone1,1"]) deviceName = @"iPhone";            // iPhone 2G GSM
    else if ([machineName isEqualToString:@"iPhone1,2"]) deviceName = @"iPhone-3G";         // iPhone 3G GSM
    else if ([machineName isEqualToString:@"iPhone2,1"]) deviceName = @"iPhone-3GS";        // iPhone 3GS GSM
    else if ([machineName isEqualToString:@"iPhone3,1"]) deviceName = @"iPhone4";           // iPhone 4 GSM
    else if ([machineName isEqualToString:@"iPhone3,2"]) deviceName = @"iPhone4";           // iPhone 4 GSM Rev A
    else if ([machineName isEqualToString:@"iPhone3,3"]) deviceName = @"iPhone4";           // iPhone 4 CDMA
    else if ([machineName isEqualToString:@"iPhone4,1"]) deviceName = @"iPhone4S";          // iPhone 4S
    else if ([machineName isEqualToString:@"iPhone5,1"]) deviceName = @"iPhone5";           // iPhone 5 GSM
    else if ([machineName isEqualToString:@"iPhone5,2"]) deviceName = @"iPhone5";           // iPhone 5 GSM+CDMA
    else if ([machineName isEqualToString:@"iPhone5,3"]) deviceName = @"iPhone5c";          // iPhone 5c GSM
    else if ([machineName isEqualToString:@"iPhone5,4"]) deviceName = @"iPhone5c";          // iPhone 5c Global
    else if ([machineName isEqualToString:@"iPhone6,1"]) deviceName = @"iPhone5s";          // iPhone 5s GSM
    else if ([machineName isEqualToString:@"iPhone6,2"]) deviceName = @"iPhone5s";          // iPhone 5s Global
    else if ([machineName isEqualToString:@"i386"]) deviceName = [self simulatorNamePhone]; // iPhone Simulator
    else if ([machineName isEqualToString:@"x86_64"]) deviceName = [self simulatorNamePad]; // iPad Simulator
    else deviceName = @"Unknown";
    
    return deviceName;
}

@end
