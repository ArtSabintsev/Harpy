//
//  Harpy.h
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HarpyDelegate <NSObject>

@optional
- (void)harpyDidShowUpdateDialog;       // User presented with update dialog
- (void)harpyUserDidLaunchAppStore;     // User did click on button that launched App Store.app
- (void)harpyUserDidSkipVersion;        // User did click on button that skips version update
- (void)harpyUserDidCancel;             // User did click on button that cancels update dialog

@end

typedef NS_ENUM(NSUInteger, HarpyAlertType)
{

    HarpyAlertTypeForce,    // Forces user to update your app
    HarpyAlertTypeOption,   // (DEFAULT) Presents user with option to update app now or at next launch
    HarpyAlertTypeSkip      // Presents User with option to update the app now, at next launch, or to skip this version all together

};

@interface Harpy : NSObject

/**
 The harpy delegate can be used to know when the update dialog is shown and which action a user took.
 See the @protocol declaration above.
 */
@property (weak, nonatomic) id<HarpyDelegate> delegate;

/**
 The app id of your app.
 */
@property (strong, nonatomic) NSString *appID;

/**
 The alert type to present to the user when there is an update. See the `HarpyAlertType` enum above.
 */
@property (assign, nonatomic) HarpyAlertType alertType;

/**
 The country code to use when querying the iTunes store. This
 is required when the application is not availabe in the U.S. Store.
 */
@property (copy, nonatomic) NSString *countryCode;

/**
 The shared Harpy instance.
 */
+ (id)sharedInstance;

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
- (void)checkVersion;

/*
 Perform daily check for new version of your app
 Useful if user returns to you app from background after extended period of time
 Place in applicationDidBecomeActive:
 */
- (void)checkVersionDaily;

/*
 Perform weekly check for new version of your app
 Useful if user returns to you app from background after extended period of time
 Place in applicationDidBecomeActive:
 */
- (void)checkVersionWeekly;

@end
