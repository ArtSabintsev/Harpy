//
//  Harpy.h
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning Please customize Harpy's static variables

// Your AppID - found in iTunes Connect
static NSString *appID = @"556665733";      

// Set to your region's local
#define kCurrentLocale  @"en_US"

/*
 
 -FOR PRODUCTION-
 To sneak in this feature through Apple's reviewers, change this number ON THE DAY you build and submit this app to the iTunes Store.
 The number 14 (e.g., 2 weeks) is a safe bet most times of the year. To double check, check the following site for AppStore review times and add some buffer: http://reviewtimes.shinydevelopment.com/
 
 -FOR DEVELOPMENT-
 Set the number to 0 to debug this feature
 
 */
#define kDaysToWaitBeforeAlertingUser   14

/*
 YES forces your users to update your app every time they launch a new session of your app.
 NO gives the user the option to update or to continue using the app for that session.
*/
static BOOL forceUpdate = YES;

/*
 Customize the alert title, message, and button titles.
 */
static NSString *alertTitle = @"Update Available";
static NSString *alertMessage = @"A new version of <app> is available. Would you like to update now?";
static NSString *cancelTitle = @"Not now";
static NSString *updateTitle = @"Update";

@interface Harpy : NSObject <UIAlertViewDelegate>

/*
  Checks the installed version of your application against the version currently available on the iTunes store.
  If a newer version exists in the AppStore, it prompts the user to update the app.
 */
+ (void)checkVersion;

@end