//
//  Harpy.h
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning Please customize these Harpy variables
static NSString *appID = @"556665733";  // Found on iTunes Connect
static BOOL forceUpdate = YES;           // YES forces the user to update on app launch. No gives the user the option to update or to continue using the app for that session.

@interface Harpy : NSObject <UIAlertViewDelegate>

/*
  Checks the installed version of your application against the version currently available on the iTunes store.
  If a newer version exists in the AppStore, it prompts the user to update the app.
 */
+ (void)checkVersion;

@end