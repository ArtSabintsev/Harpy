//
//  Harpy.h
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

/// i18n/l10n constants
FOUNDATION_EXPORT NSString * const HarpyLanguageBasque;
FOUNDATION_EXPORT NSString * const HarpyLanguageChineseSimplified;
FOUNDATION_EXPORT NSString * const HarpyLanguageChineseTraditional;
FOUNDATION_EXPORT NSString * const HarpyLanguageDanish;
FOUNDATION_EXPORT NSString * const HarpyLanguageDutch;
FOUNDATION_EXPORT NSString * const HarpyLanguageEnglish;
FOUNDATION_EXPORT NSString * const HarpyLanguageFrench;
FOUNDATION_EXPORT NSString * const HarpyLanguageGerman;
FOUNDATION_EXPORT NSString * const HarpyLanguageItalian;
FOUNDATION_EXPORT NSString * const HarpyLanguageJapanese;
FOUNDATION_EXPORT NSString * const HarpyLanguageKorean;
FOUNDATION_EXPORT NSString * const HarpyLanguagePortuguese;
FOUNDATION_EXPORT NSString * const HarpyLanguageRussian;
FOUNDATION_EXPORT NSString * const HarpyLanguageSlovenian;
FOUNDATION_EXPORT NSString * const HarpyLanguageSpanish;

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
 See the protocol declaration above.
 */
@property (weak, nonatomic) id<HarpyDelegate> delegate;

/**
 The app id of your app.
 */
@property (strong, nonatomic) NSString *appID;

/**
 @b OPTIONAL: The preferred name for the app. This name will be displayed in the @c UIAlertView in place of the bundle name.
 */
@property (strong, nonatomic) NSString *appName;

/**
 @b OPTIONAL: The alert type to present to the user when there is an update. See the @c HarpyAlertType enum above.
 */
@property (assign, nonatomic) HarpyAlertType alertType;

/**
 @b OPTIONAL: The alert type to present to the user when there is a patch update (e.g. version 2.1.3). See the @c HarpyAlertType enum above.
 */
@property (assign, nonatomic) HarpyAlertType patchUpdateAlertType;

/**
 @b OPTIONAL: The alert type to present to the user when there is a minor update (e.g. version 2.1.0). See the @c HarpyAlertType enum above.
 */
@property (assign, nonatomic) HarpyAlertType minorUpdateAlertType;

/**
 @b OPTIONAL: The alert type to present to the user when there is a major update (e.g. version 2.0). See the @c HarpyAlertType enum above.
 */
@property (assign, nonatomic) HarpyAlertType majorUpdateAlertType;


/**
 @b OPTIONAL: If your application is not availabe in the U.S. Store, you must specify the two-letter
 country code for the region in which your applicaiton is available in.
 */
@property (copy, nonatomic) NSString *countryCode;

/**
 @b OPTIONAL: Overides system language to predefined language. Please use the @c HarpyLanguage constants defined in @c Harpy.h.
 */
@property (copy, nonatomic) NSString *forceLanguageLocalization;

/**
 Harpy's Singleton method
 */
+ (Harpy *)sharedInstance;

/**
 Checks the installed version of your application against the version currently available on the iTunes store.
 If a newer version exists in the AppStore, Harpy prompts your user to update their copy of your app.
 Place in @c application:didFinishLaunchingWithOptions: @b AFTER calling @c makeKeyAndVisible on your @c UIWindow iVar.
 
 Do not use this method if you are using checkVersionDaily or checkVersionWeekly.
 */
- (void)checkVersion;

/**
 Perform daily check for new version of your app.
 Useful if user returns to you app from background after extended period of time.
 Place in @c applicationDidBecomeActive:.
 
 Do not use this method if you are using @c checkVersion or @c checkVersionWeekly.
 */
- (void)checkVersionDaily;

/**
 Perform weekly check for new version of your app.
 Useful if user returns to you app from background after extended period of time.
 Place in @c applicationDidBecomeActive:.
 
 Do not use this method if you are using @c checkVersion or @c checkVersionDaily.
 */
- (void)checkVersionWeekly;

@end
