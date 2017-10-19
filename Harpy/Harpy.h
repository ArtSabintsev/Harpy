//
//  Harpy.h
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for Harpy.
FOUNDATION_EXPORT double HarpyVersionNumber;

//! Project version string for Harpy.
FOUNDATION_EXPORT const unsigned char HarpyVersionString[];

/// i18n/l10n constants
FOUNDATION_EXPORT NSString * const HarpyLanguageArabic;
FOUNDATION_EXPORT NSString * const HarpyLanguageArmenian;
FOUNDATION_EXPORT NSString * const HarpyLanguageBasque;
FOUNDATION_EXPORT NSString * const HarpyLanguageChineseSimplified;
FOUNDATION_EXPORT NSString * const HarpyLanguageChineseTraditional;
FOUNDATION_EXPORT NSString * const HarpyLanguageCroatian;
FOUNDATION_EXPORT NSString * const HarpyLanguageCzech;
FOUNDATION_EXPORT NSString * const HarpyLanguageDanish;
FOUNDATION_EXPORT NSString * const HarpyLanguageDutch;
FOUNDATION_EXPORT NSString * const HarpyLanguageEnglish;
FOUNDATION_EXPORT NSString * const HarpyLanguageEstonian;
FOUNDATION_EXPORT NSString * const HarpyLanguageFinnish;
FOUNDATION_EXPORT NSString * const HarpyLanguageFrench;
FOUNDATION_EXPORT NSString * const HarpyLanguageGerman;
FOUNDATION_EXPORT NSString * const HarpyLanguageGreek;
FOUNDATION_EXPORT NSString * const HarpyLanguageHebrew;
FOUNDATION_EXPORT NSString * const HarpyLanguageHungarian;
FOUNDATION_EXPORT NSString * const HarpyLanguageIndonesian;
FOUNDATION_EXPORT NSString * const HarpyLanguageItalian;
FOUNDATION_EXPORT NSString * const HarpyLanguageJapanese;
FOUNDATION_EXPORT NSString * const HarpyLanguageKorean;
FOUNDATION_EXPORT NSString * const HarpyLanguageLatvian;
FOUNDATION_EXPORT NSString * const HarpyLanguageLithuanian;
FOUNDATION_EXPORT NSString * const HarpyLanguageMalay;
FOUNDATION_EXPORT NSString * const HarpyLanguageNorwegian;
FOUNDATION_EXPORT NSString * const HarpyLanguagePersian;
FOUNDATION_EXPORT NSString * const HarpyLanguagePersianIran;
FOUNDATION_EXPORT NSString * const HarpyLanguagePersianAfghanistan;
FOUNDATION_EXPORT NSString * const HarpyLanguagePolish;
FOUNDATION_EXPORT NSString * const HarpyLanguagePortugueseBrazil;
FOUNDATION_EXPORT NSString * const HarpyLanguagePortuguesePortugal;
FOUNDATION_EXPORT NSString * const HarpyLanguageRussian;
FOUNDATION_EXPORT NSString * const HarpyLanguageSerbianCyrillic;
FOUNDATION_EXPORT NSString * const HarpyLanguageSerbianLatin;
FOUNDATION_EXPORT NSString * const HarpyLanguageSlovenian;
FOUNDATION_EXPORT NSString * const HarpyLanguageSwedish;
FOUNDATION_EXPORT NSString * const HarpyLanguageSpanish;
FOUNDATION_EXPORT NSString * const HarpyLanguageThai;
FOUNDATION_EXPORT NSString * const HarpyLanguageTurkish;
FOUNDATION_EXPORT NSString * const HarpyLanguageUkrainian;
FOUNDATION_EXPORT NSString * const HarpyLanguageUrdu;
FOUNDATION_EXPORT NSString * const HarpyLanguageVietnamese;

@protocol HarpyDelegate <NSObject>

@optional
- (void)harpyDidShowUpdateDialog;       // User presented with update dialog
- (void)harpyUserDidLaunchAppStore;     // User did click on button that launched App Store.app
- (void)harpyUserDidSkipVersion;        // User did click on button that skips version update
- (void)harpyUserDidCancel;             // User did click on button that cancels update dialog
- (void)harpyDidDetectNewVersionWithoutAlert:(NSString *)message; // Harpy performed version check and did not display alert
@end

typedef NS_ENUM(NSUInteger, HarpyAlertType)
{
    HarpyAlertTypeForce = 1,    // Forces user to update your app
    HarpyAlertTypeOption,       // (DEFAULT) Presents user with option to update app now or at next launch
    HarpyAlertTypeSkip,         // Presents User with option to update the app now, at next launch, or to skip this version all together
    HarpyAlertTypeNone          // Don't show the alert type , useful for skipping Patch, Minor, Major updates
};

@interface Harpy : NSObject

/**
 The harpy delegate can be used to know when the update dialog is shown and which action a user took.
 See the protocol declaration above.
 */
@property (nonatomic, weak) id<HarpyDelegate> delegate;

/**
 The UIViewController that will present an instance of UIAlertController
 */
@property (nonatomic, strong) UIViewController *presentingViewController;

/**
 The current version of your app that is available for download on the App Store
 */
@property (nonatomic, copy, readonly) NSString *currentAppStoreVersion;


/**
 @b OPTIONAL: The preferred name for the app. This name will be displayed in the @c UIAlertView in place of the bundle name.
 */
@property (nonatomic, strong) NSString *appName;

/**
 @b OPTIONAL: Log Debug information
 */
@property (nonatomic, assign, getter=isDebugEnabled) BOOL debugEnabled;

/**
 @b OPTIONAL: The alert type to present to the user when there is an update. See the @c HarpyAlertType enum above.
 */
@property (nonatomic, assign) HarpyAlertType alertType;

/**
 @b OPTIONAL: The alert type to present to the user when there is a major update (e.g. A.b.c.d). See the @c HarpyAlertType enum above.
 */
@property (nonatomic, assign) HarpyAlertType majorUpdateAlertType;

/**
 @b OPTIONAL: The alert type to present to the user when there is a minor update (e.g. a.B.c.d). See the @c HarpyAlertType enum above.
 */
@property (nonatomic, assign) HarpyAlertType minorUpdateAlertType;

/**
 @b OPTIONAL: The alert type to present to the user when there is a patch update (e.g. a.b.C.d). See the @c HarpyAlertType enum above.
 */
@property (nonatomic, assign) HarpyAlertType patchUpdateAlertType;

/**
 @b OPTIONAL: The alert type to present to the user when there is a minor update (e.g. a.b.c.D). See the @c HarpyAlertType enum above.
 */
@property (nonatomic, assign) HarpyAlertType revisionUpdateAlertType;

/**
 @b OPTIONAL: If your application is not availabe in the U.S. Store, you must specify the two-letter
 country code for the region in which your applicaiton is available in.
 */
@property (nonatomic, copy) NSString *countryCode;

/**
 @b OPTIONAL: Overides system language to predefined language. Please use the @c HarpyLanguage constants defined in @c Harpy.h.
 */
@property (nonatomic, copy) NSString *forceLanguageLocalization;

/**
 @b OPTIONAL: The tintColor for the alertController
 */
@property (nonatomic, strong) UIColor *alertControllerTintColor;

/**
 @b OPTIONAL: Delays the update prompt by a specific number of days. By default, this value is set to 1 day to avoid an issue where Apple updates the JSON faster than the app binary propogates to the App Store.
 */
@property (nonatomic, assign) NSUInteger showAlertAfterCurrentVersionHasBeenReleasedForDays;

#pragma mark - Methods

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

#pragma mark - Unit Testing

/**
 This method was created for unit testing purposes.
 
 It will specifically be used to test the string localizations.

 @param stringKey The string that should be looked up and localized.

 @return The localized string.
 */

- (NSString *)testLocalizedStringForKey:(NSString *)stringKey;

/**
 This method was created for unit testing purposes.

 It will specifically be used to temporarily set the installed version of the app.

 @param version The temporary version that should be set for the app.

 */

- (void)testSetCurrentInstalledVersion:(NSString *)version;


/**
 This method was created for unit testing purposes.

 It will specifically be used to temporarily set the app store version of the app.
 
 @param version The temporary version that should be set for the app.

 */

- (void)testSetCurrentAppStoreVersion:(NSString *)version;

/**
 This method was created for unit testing purposes.

 It will specifically be used to compared the temporary app store version to the temporary installed version.

 @return True if app store version is newer, otherwise false.

 */

- (BOOL)testIsAppStoreVersionNewer;


@end
