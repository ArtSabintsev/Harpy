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
- (void)harpyDidShowUpdateDialog;
- (void)harpyUserDidLaunchAppStore;
- (void)harpyUserDidSkipVersion;
- (void)harpyUserDidCancel;

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
@property (nonatomic) enum HarpyAlertType alertType;

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
