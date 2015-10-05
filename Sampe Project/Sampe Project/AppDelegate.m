//
//  AppDelegate.m
//  Sample Project
//
//  Created by Sabintsev, Arthur on 10/4/15.
//  Copyright © 2015 Arthur Ariel Sabintsev. All rights reserved.
//

#import "AppDelegate.h"
#import "Harpy.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Present Window before calling Harpy
    [self.window makeKeyAndVisible];

    // Set the App ID for your app
    [[Harpy sharedInstance] setAppID:@"376771144"];

    // Set the UIViewController that will present an instance of UIAlertController
    [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];

    // (Optional) The tintColor for the alertController
//    [[Harpy sharedInstance] setAlertControllerTintColor:[UIColor purpleColor]];

    // (Optional) Set the App Name for your app
//    [[Harpy sharedInstance] setAppName:@"iTunes Connect Mobile"];

    /* (Optional) Set the Alert Type for your app
     By default, Harpy is configured to use HarpyAlertTypeOption */
//    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];

    /* (Optional) If your application is not available in the U.S. App Store, you must specify the two-letter
     country code for the region in which your applicaiton is available. */
//    [[Harpy sharedInstance] setCountryCode:@"en-US"];

    /* (Optional) Overides system language to predefined language.
     Please use the HarpyLanguage constants defined in Harpy.h. */
    [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageEstonian];

    // Perform check for new version of your app
    [[Harpy sharedInstance] checkVersion];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
