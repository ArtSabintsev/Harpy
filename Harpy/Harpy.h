//
//  Harpy.h
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Harpy : NSObject <UIAlertViewDelegate>

/**
  Checks the installed version of your application against the version currently available on the iTunes store.
  If a newer version exists in the AppStore, Harpy prompts your user to update their copy of your app.
 */

/**
 NOTE: ONLY USE ONE OF THE METHODS BELOW, AS THEY ALL PERFORM A CHECK ON YOUR APPLICATION'S FIRST LAUNCH
 USING MULTIPLE METHODS WILL CAUSE MULTIPLE UIALERTVIEWS TO POP UP.
 */

/* 
 Perform check for new version of your app
 Place in application:didFinishLaunchingWithOptions: AFTER calling makeKeyAndVisible on your UIWindow iVar
 */
+ (void)checkVersion;

/*
 Perform daily check for new version of your app
 Useful if user returns to you app from background after extended period of time
 Place in applicationDidBecomeActive:
 */
+ (void)checkVersionDaily;

/*
 Perform weekly check for new version of your app
 Useful if user returns to you app from background after extended period of time
 Place in applicationDidBecomeActive:
 */
+ (void)checkVersionWeekly;

@end
