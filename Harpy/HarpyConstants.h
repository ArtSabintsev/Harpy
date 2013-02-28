//
//  HarpyConstants.h
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 1/30/13.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//


#pragma mark - Non-Customizable Declarations
/// Structure defining type of UIAlertView to display
typedef NS_ENUM(NSUInteger, AlertType)
{
    
    AlertType_Force,    // Forces user to update your app
    AlertType_Option,   // (DEFAULT) Presents user with option to update app now or at next launch
    AlertType_Skip      // Presents User with option to update the app now, at next launch, or to skip this version all together
    
};

/// NSUserDefault Macro to store user's preferences for AlertType_Skip
#define kHarpyDefaultShouldSkipVersion      @"Harpy Should Skip Version Boolean"
#define kHarpyDefaultSkippedVersion         @"Harpy User Decided To Skip Version Update Boolean"

/************************/
/** BEGIN CUSTOMIZATION */
/************************/

/// 1. Alert Type (Force, Option, or Skip)
#ifndef kHarpyAlertType
    #define kHarpyAlertType                     AlertType_Option // Choose between AlertType_Force, AlertType_Option, or AlertType_Skip
#endif

/// 2. Your AppID (found in iTunes Connect)
#ifndef kHarpyAppID
    #warning Please re-define kHarpyAppID macro in your pch file
    #define kHarpyAppID                         @"573293275"
#endif

/************************/
/** END CUSTOMIZATION ***/
/************************/