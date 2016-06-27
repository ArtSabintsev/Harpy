//
//  AppDelegate.m
//  Sample Project
//
//  Created by Sabintsev, Arthur on 10/4/15.
//  Copyright © 2015 Arthur Ariel Sabintsev. All rights reserved.
//

#import "AppDelegate.h"
#import "Harpy.h"

@interface AppDelegate () <HarpyDelegate>

@end

@implementation AppDelegate 


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Present Window before calling Harpy
    [self.window makeKeyAndVisible];

    // Set the UIViewController that will present an instance of UIAlertController
    [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];

    // (Optional) Set the Delegate to track what a user clicked on, or to use a custom UI to present your message.
    [[Harpy sharedInstance] setDelegate:self];

    // (Optional) The tintColor for the alertController
//    [[Harpy sharedInstance] setAlertControllerTintColor:[UIColor purpleColor]];

    // (Optional) Set the App Name for your app
//    [[Harpy sharedInstance] setAppName:@"iTunes Connect Mobile"];

    /* (Optional) Set the Alert Type for your app
     By default, Harpy is configured to use HarpyAlertTypeOption */
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];

    /* (Optional) If your application is not available in the U.S. App Store, you must specify the two-letter
     country code for the region in which your applicaiton is available. */
//    [[Harpy sharedInstance] setCountryCode:@"en-US"];

    /* (Optional) Overrides system language to predefined language.
     Please use the HarpyLanguage constants defined in Harpy.h. */
//    [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageRussian];

    // Perform check for new version of your app
    [[Harpy sharedInstance] checkVersion];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

    /*
     Perform daily check for new version of your app
     Useful if user returns to you app from background after extended period of time
     Place in applicationDidBecomeActive:

     Also, performs version check on first launch.
     */
//    [[Harpy sharedInstance] checkVersionDaily];

    /*
     Perform weekly check for new version of your app
     Useful if you user returns to your app from background after extended period of time
     Place in applicationDidBecomeActive:

     Also, performs version check on first launch.
     */
//    [[Harpy sharedInstance] checkVersionWeekly];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Perform check for new version of your app
     Useful if user returns to you app from background after being sent tot he App Store,
     but doesn't update their app before coming back to your app.

     ONLY USE THIS IF YOU ARE USING *HarpyAlertTypeForce*

     Also, performs version check on first launch.
     */
//    [[Harpy sharedInstance] checkVersion];
}

#pragma mark - HarpyDelegate
- (void)harpyDidShowUpdateDialog
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)harpyUserDidLaunchAppStore
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)harpyUserDidSkipVersion
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)harpyUserDidCancel
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)harpyDidDetectNewVersionWithoutAlert:(NSString *)message
{
    NSLog(@"%@", message);
}

@end
