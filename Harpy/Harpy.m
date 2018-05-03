//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"

/// NSUserDefault macros to store user's preferences for HarpyAlertTypeSkip
NSString * const HarpyDefaultSkippedVersion         = @"Harpy User Decided To Skip Version Update Boolean";
NSString * const HarpyDefaultStoredVersionCheckDate = @"Harpy Stored Date From Last Version Check";

/// i18n/l10n constants
NSString * const HarpyLanguageArabic                = @"ar";
NSString * const HarpyLanguageArmenian              = @"hy";
NSString * const HarpyLanguageBasque                = @"eu";
NSString * const HarpyLanguageChineseSimplified     = @"zh-Hans";
NSString * const HarpyLanguageChineseTraditional    = @"zh-Hant";
NSString * const HarpyLanguageCroatian              = @"hr";
NSString * const HarpyLanguageCzech                 = @"cs";
NSString * const HarpyLanguageDanish                = @"da";
NSString * const HarpyLanguageDutch                 = @"nl";
NSString * const HarpyLanguageEnglish               = @"en";
NSString * const HarpyLanguageEstonian              = @"et";
NSString * const HarpyLanguageFinnish               = @"fi";
NSString * const HarpyLanguageFrench                = @"fr";
NSString * const HarpyLanguageGerman                = @"de";
NSString * const HarpyLanguageGreek                 = @"el";
NSString * const HarpyLanguageHebrew                = @"he";
NSString * const HarpyLanguageHungarian             = @"hu";
NSString * const HarpyLanguageIndonesian            = @"id";
NSString * const HarpyLanguageItalian               = @"it";
NSString * const HarpyLanguageJapanese              = @"ja";
NSString * const HarpyLanguageKorean                = @"ko";
NSString * const HarpyLanguageLatvian               = @"lv";
NSString * const HarpyLanguageLithuanian            = @"lt";
NSString * const HarpyLanguageMalay                 = @"ms";
NSString * const HarpyLanguageNorwegian             = @"nb-NO";
NSString * const HarpyLanguagePersian               = @"fa";
NSString * const HarpyLanguagePersianIran           = @"fa-IR";
NSString * const HarpyLanguagePersianAfghanistan    = @"fa-AF";
NSString * const HarpyLanguagePolish                = @"pl";
NSString * const HarpyLanguagePortugueseBrazil      = @"pt";
NSString * const HarpyLanguagePortuguesePortugal    = @"pt-PT";
NSString * const HarpyLanguageRussian               = @"ru";
NSString * const HarpyLanguageSerbianCyrillic       = @"sr-Cyrl";
NSString * const HarpyLanguageSerbianLatin          = @"sr-Latn";
NSString * const HarpyLanguageSlovenian             = @"sl";
NSString * const HarpyLanguageSwedish               = @"sv";
NSString * const HarpyLanguageSpanish               = @"es";
NSString * const HarpyLanguageThai                  = @"th";
NSString * const HarpyLanguageTurkish               = @"tr";
NSString * const HarpyLanguageUkrainian             = @"uk";
NSString * const HarpyLanguageUrdu                  = @"ur";
NSString * const HarpyLanguageVietnamese            = @"vi";

@interface Harpy()

@property (nonatomic, strong) NSDictionary <NSString *, id> *appData;
@property (nonatomic, strong) NSDate *lastVersionCheckPerformedOnDate;
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *currentInstalledVersion;
@property (nonatomic, copy) NSString *currentAppStoreVersion;
@property (nonatomic, copy) NSString *updateAvailableMessage;
@property (nonatomic, copy) NSString *theNewVersionMessage;
@property (nonatomic, copy) NSString *updateButtonText;
@property (nonatomic, copy) NSString *nextTimeButtonText;
@property (nonatomic, copy) NSString *skipButtonText;

@end

@implementation Harpy

#pragma mark - Initialization

+ (Harpy *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (id)init {
    self = [super init];

    if (self) {
        _alertType = HarpyAlertTypeOption;
        _lastVersionCheckPerformedOnDate = [[NSUserDefaults standardUserDefaults] objectForKey:HarpyDefaultStoredVersionCheckDate];
        _currentInstalledVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        _showAlertAfterCurrentVersionHasBeenReleasedForDays = 1;
    }

    return self;
}

#pragma mark - Public

- (void)checkVersion {
    if (!_presentingViewController) {
        NSLog(@"[Harpy]: Please make sure that you have set _presentationViewController before calling checkVersion, checkVersionDaily, or checkVersionWeekly.");
    } else {
        [self performVersionCheck];
    }
}

- (void)checkVersionDaily {
    /*
     On app's first launch, lastVersionCheckPerformedOnDate isn't set.
     Avoid false-positive fulfilment of second condition in this method.
     Also, performs version check on first launch.
     */
    if (![self lastVersionCheckPerformedOnDate]) {

        // Set Initial Date
        self.lastVersionCheckPerformedOnDate = [NSDate date];

        // Perform First Launch Check
        [self checkVersion];
    }

    // If daily condition is satisfied, perform version check
    if ([self numberOfDaysElapsedBetweenLastVersionCheckDate] >= 1) {
        [self checkVersion];
    }
}

- (void)checkVersionWeekly {
    /*
     On app's first launch, lastVersionCheckPerformedOnDate isn't set.
     Avoid false-positive fulfilment of second condition in this method.
     Also, performs version check on first launch.
     */
    if (![self lastVersionCheckPerformedOnDate]) {

        // Set Initial Date
        self.lastVersionCheckPerformedOnDate = [NSDate date];

        // Perform First Launch Check
        [self checkVersion];
    }

    // If weekly condition is satisfied, perform version check
    if ([self numberOfDaysElapsedBetweenLastVersionCheckDate] >= 7) {
        [self checkVersion];
    }
}

#pragma mark - Helpers

- (void)performVersionCheck {
    NSURL *storeURL = [self itunesURL];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:storeURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];

    [self printDebugMessage:[NSString stringWithFormat:@"storeURL: %@", storeURL]];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if ([data length] > 0 && !error) { // Success
                                                    [self parseResults:data];
                                                }
                                            }];
    [task resume];
}

- (void)parseResults:(NSData *)data {
    _appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    [self printDebugMessage:[NSString stringWithFormat:@"JSON Results: %@", _appData]];

    if ([self isUpdateCompatibleWithDeviceOS:_appData]) {

        __typeof__(self) __weak weakSelf = self;

        dispatch_async(dispatch_get_main_queue(), ^{

            // Store version comparison date
            weakSelf.lastVersionCheckPerformedOnDate = [NSDate date];
            [[NSUserDefaults standardUserDefaults] setObject:[self lastVersionCheckPerformedOnDate] forKey:HarpyDefaultStoredVersionCheckDate];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSDictionary<NSString *, id> *results = [self.appData valueForKey:@"results"];

            /**
             Checks to see when the latest version of the app was released.
             If the release date is greater-than-or-equal-to `_showAlertAfterCurrentVersionHasBeenReleasedForDays`,
             the user will prompted to update their app (if the version is newer - checked later on in this method).
             */

            NSString *releaseDateString = [[results valueForKey:@"currentVersionReleaseDate"] objectAtIndex:0];
            if (releaseDateString == nil) {
                return;
            } else {
                NSInteger daysSinceRelease = [weakSelf daysSinceDateString:releaseDateString];
                if (!(daysSinceRelease >= weakSelf.showAlertAfterCurrentVersionHasBeenReleasedForDays)) {
                    NSString *message = [NSString stringWithFormat:@"Your app has been released for %ld days, but Harpy cannot prompt the user until %lu days have passed.", (long)daysSinceRelease, (unsigned long)weakSelf.showAlertAfterCurrentVersionHasBeenReleasedForDays];
                    [self printDebugMessage:message];
                    return;
                }
            }

            /**
             Current version that has been uploaded to the AppStore.
             Used to contain all versions, but now only contains the latest version.
             Still returns an instance of NSArray.
             */

            NSArray *versionsInAppStore = [results valueForKey:@"version"];
            if (versionsInAppStore == nil) {
                return;
            } else {
                if ([versionsInAppStore count]) {
                    weakSelf.currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    if ([weakSelf isAppStoreVersionNewer:weakSelf.currentAppStoreVersion]) {
                        [weakSelf appStoreVersionIsNewer:weakSelf.currentAppStoreVersion];
                    } else {
                        [self printDebugMessage:@"Currently installed version is newer."];
                    }
                }
            }
        });
    } else {
        [self printDebugMessage:@"Device is incompatible with installed verison of iOS."];
    }
}

- (NSURL *)itunesURL {
    NSURLComponents *components = [NSURLComponents new];
    components.scheme = @"https";
    components.host = @"itunes.apple.com";
    components.path = @"/lookup";

    NSMutableArray<NSURLQueryItem *> *items = [@[[NSURLQueryItem queryItemWithName:@"bundleId" value:[self bundleID]]] mutableCopy];

    if ([self countryCode]) {
        NSURLQueryItem *countryQueryItem = [NSURLQueryItem queryItemWithName:@"country" value:_countryCode];
        [items addObject:countryQueryItem];
    }

    components.queryItems = items;

    return components.URL;
}

- (BOOL)isUpdateCompatibleWithDeviceOS:(NSDictionary<NSString *, id> *)appData {
    NSArray<NSDictionary<NSString *, id> *> *results = appData[@"results"];

    if (results.count > 0) {
        NSString *requiresOSVersion = [results firstObject][@"minimumOsVersion"];
        if (requiresOSVersion != nil) {
            NSString *systemVersion = [UIDevice currentDevice].systemVersion;
            if (
                ([systemVersion compare:requiresOSVersion options:NSNumericSearch] == NSOrderedDescending) ||
                ([systemVersion compare:requiresOSVersion options:NSNumericSearch] == NSOrderedSame)
                ) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    } else {
        return false;
    }
}

- (NSUInteger)numberOfDaysElapsedBetweenLastVersionCheckDate {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitDay
                                                      fromDate:[self lastVersionCheckPerformedOnDate]
                                                        toDate:[NSDate date]
                                                       options:0];
    return [components day];
}

- (BOOL)isAppStoreVersionNewer:(NSString *)currentAppStoreVersion {
    // Current installed version is the newest public version or newer (e.g., dev version)
    if ([[self currentInstalledVersion] compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
        return true;
    } else {
        return false;
    }
}

- (void)appStoreVersionIsNewer:(NSString *)currentAppStoreVersion {
    _appID = _appData[@"results"][0][@"trackId"];

    if (_appID == nil) {
        [self printDebugMessage:@"appID is nil, which means to the trackId key is missing from the JSON results that Apple returned for your bundleID. If a version of your app is in the store and you are seeing this message, please open up an issue http://github.com/ArtSabintsev/Harpy and provide as much detail about your app as you can. Thanks!"];
    } else {
        [self localizeAlertStringsForCurrentAppStoreVersion:currentAppStoreVersion];
        [self alertTypeForVersion:currentAppStoreVersion];
        [self showAlertIfCurrentAppStoreVersionNotSkipped:currentAppStoreVersion];
    }
}

- (void)launchAppStore {
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", [self appID]];
    NSURL *iTunesURL = [NSURL URLWithString:iTunesString];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:iTunesURL options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:iTunesURL];
        }

        if ([self.delegate respondsToSelector:@selector(harpyUserDidLaunchAppStore)]){
            [self.delegate harpyUserDidLaunchAppStore];
        }
    });
}

#pragma mark - Alert Management

- (void)showAlertIfCurrentAppStoreVersionNotSkipped:(NSString *)currentAppStoreVersion {
    // Check if user decided to skip this version in the past
    NSString *storedSkippedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:HarpyDefaultSkippedVersion];

    if (![storedSkippedVersion isEqualToString:currentAppStoreVersion]) {
        [self showAlertWithAppStoreVersion:currentAppStoreVersion];
    } else {
        // Don't show alert.
        return;
    }
}

- (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion {
    // Show Appropriate UIAlertView
    switch ([self alertType]) {

        case HarpyAlertTypeForce: {

            UIAlertController *alertController = [self createAlertController];
            [alertController addAction:[self updateAlertAction]];

            [self showAlertController:alertController];

        } break;

        case HarpyAlertTypeOption: {

            UIAlertController *alertController = [self createAlertController];
            [alertController addAction:[self nextTimeAlertAction]];
            [alertController addAction:[self updateAlertAction]];

            [self showAlertController:alertController];

        } break;

        case HarpyAlertTypeSkip: {

            UIAlertController *alertController = [self createAlertController];
            [alertController addAction:[self skipAlertAction]];
            [alertController addAction:[self nextTimeAlertAction]];
            [alertController addAction:[self updateAlertAction]];

            [self showAlertController:alertController];

        } break;

        case HarpyAlertTypeNone: { //If the delegate is set, pass a localized update message. Otherwise, do nothing.
            if ([self.delegate respondsToSelector:@selector(harpyDidDetectNewVersionWithoutAlert:)]) {
                [self.delegate harpyDidDetectNewVersionWithoutAlert:_theNewVersionMessage];
            }
        } break;
    }
}

- (void)showAlertController:(UIAlertController *)alertController {

    if (_presentingViewController != nil) {
        [_presentingViewController presentViewController:alertController animated:YES completion:nil];

        if (_alertControllerTintColor) {
            [alertController.view setTintColor:_alertControllerTintColor];
        }
    }

    if ([self.delegate respondsToSelector:@selector(harpyDidShowUpdateDialog)]){
        [self.delegate harpyDidShowUpdateDialog];
    }
}

- (UIAlertController *)createAlertController {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_updateAvailableMessage
                                                                             message:_theNewVersionMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    return alertController;
}

- (void)alertTypeForVersion:(NSString *)currentAppStoreVersion {
    // Check what version the update is, major, minor or a patch
    NSArray *oldVersionComponents = [[self currentInstalledVersion] componentsSeparatedByString:@"."];
    NSArray *newVersionComponents = [currentAppStoreVersion componentsSeparatedByString: @"."];

    BOOL oldVersionComponentIsProperFormat = (2 <= [oldVersionComponents count] && [oldVersionComponents count] <= 4);
    BOOL newVersionComponentIsProperFormat = (2 <= [newVersionComponents count] && [newVersionComponents count] <= 4);

    if (oldVersionComponentIsProperFormat && newVersionComponentIsProperFormat) {
        if ([newVersionComponents[0] integerValue] > [oldVersionComponents[0] integerValue]) { // A.b.c.d
            if (_majorUpdateAlertType) _alertType = _majorUpdateAlertType;
        } else if ([newVersionComponents[1] integerValue] > [oldVersionComponents[1] integerValue]) { // a.B.c.d
            if (_minorUpdateAlertType) _alertType = _minorUpdateAlertType;
        } else if ((newVersionComponents.count > 2) && (oldVersionComponents.count <= 2 || ([newVersionComponents[2] integerValue] > [oldVersionComponents[2] integerValue]))) { // a.b.C.d
            if (_patchUpdateAlertType) _alertType = _patchUpdateAlertType;
        } else if ((newVersionComponents.count > 3) && (oldVersionComponents.count <= 3 || ([newVersionComponents[3] integerValue] > [oldVersionComponents[3] integerValue]))) { // a.b.c.D
            if (_revisionUpdateAlertType) _alertType = _revisionUpdateAlertType;
        }
    }
}

- (void)localizeAlertStringsForCurrentAppStoreVersion:(NSString *)currentAppStoreVersion {
    // Reference App's name
    _appName = _appName ? _appName : [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];

    // Force localization if _forceLanguageLocalization is set
    if (_forceLanguageLocalization) {
        _updateAvailableMessage = [self forcedLocalizedStringForKey:@"Update Available"];
        _theNewVersionMessage = [NSString stringWithFormat:[self forcedLocalizedStringForKey:@"A new version of %@ is available. Please update to version %@ now."], _appName, currentAppStoreVersion];
        _updateButtonText = [self forcedLocalizedStringForKey:@"Update"];
        _nextTimeButtonText = [self forcedLocalizedStringForKey:@"Next time"];
        _skipButtonText = [self forcedLocalizedStringForKey:@"Skip this version"];
    } else {
        _updateAvailableMessage = [self localizedStringForKey:@"Update Available"];
        _theNewVersionMessage = [NSString stringWithFormat:[self localizedStringForKey:@"A new version of %@ is available. Please update to version %@ now."], _appName, currentAppStoreVersion];
        _updateButtonText = [self localizedStringForKey:@"Update"];
        _nextTimeButtonText = [self localizedStringForKey:@"Next time"];
        _skipButtonText = [self localizedStringForKey:@"Skip this version"];
    }
}

#pragma mark - NSBundle

- (NSString *)bundleID {
    return [NSBundle mainBundle].bundleIdentifier;
}

- (NSString *)bundlePath {
    return [[NSBundle bundleForClass:[self class]] pathForResource:@"Harpy" ofType:@"bundle"];
}

- (NSString *)localizedStringForKey:(NSString *)stringKey {
    return ([[NSBundle bundleForClass:[self class]] pathForResource:@"Harpy" ofType:@"bundle"] ? [[NSBundle bundleWithPath:[self bundlePath]] localizedStringForKey:stringKey value:stringKey table:@"HarpyLocalizable"] : stringKey);
}

- (NSString *)forcedLocalizedStringForKey:(NSString *)stringKey {
    NSString *path = [[NSBundle bundleWithPath:[self bundlePath]] pathForResource:[self forceLanguageLocalization] ofType:@"lproj"];
    return [[NSBundle bundleWithPath:path] localizedStringForKey:stringKey value:stringKey table:@"HarpyLocalizable"];
}

#pragma mark - NSDate

- (NSInteger)daysSinceDate:(NSDate *)date {
    NSCalendar *calendar = NSCalendar.currentCalendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date toDate:[NSDate new] options:0];
    return components.day;
}

- (NSInteger)daysSinceDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSDate *releaseDate = [dateFormatter dateFromString:dateString];
    return [self daysSinceDate:releaseDate];
}

#pragma mark - UIAlertActions

- (UIAlertAction *)updateAlertAction {
    UIAlertAction *updateAlertAction = [UIAlertAction actionWithTitle:_updateButtonText
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [self launchAppStore];
                                                              }];

    return updateAlertAction;
}

- (UIAlertAction *)nextTimeAlertAction {
    UIAlertAction *nextTimeAlertAction = [UIAlertAction actionWithTitle:_nextTimeButtonText
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    if([self.delegate respondsToSelector:@selector(harpyUserDidCancel)]){
                                                                        [self.delegate harpyUserDidCancel];
                                                                    }
                                                                }];

    return nextTimeAlertAction;
}

- (UIAlertAction *)skipAlertAction {
    __typeof__(self) __weak weakSelf = self;

    UIAlertAction *skipAlertAction = [UIAlertAction actionWithTitle:_skipButtonText
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                [[NSUserDefaults standardUserDefaults] setObject:weakSelf.currentAppStoreVersion forKey:HarpyDefaultSkippedVersion];
                                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                                if([self.delegate respondsToSelector:@selector(harpyUserDidSkipVersion)]){
                                                                    [self.delegate harpyUserDidSkipVersion];
                                                                }
                                                            }];

    return skipAlertAction;
}

#pragma mark - Logging

- (void)printDebugMessage:(NSString * _Nonnull)message {

    if ([self isDebugEnabled]) {
        NSLog(@"[Harpy]: %@", message);
    }

}

#pragma mark - Testing

- (NSString *)testLocalizedStringForKey:(NSString *)stringKey {
    return [self forcedLocalizedStringForKey:stringKey];
}

- (void)testSetCurrentInstalledVersion:(NSString *)version {
    _currentInstalledVersion = version;
}

- (void)testSetCurrentAppStoreVersion:(NSString *)version {
    _currentAppStoreVersion = version;
}

- (BOOL)testIsAppStoreVersionNewer {
    return [self isAppStoreVersionNewer:_currentAppStoreVersion];
}


@end
