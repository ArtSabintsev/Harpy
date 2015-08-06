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

/// App Store links
NSString * const HarpyAppStoreLinkUniversal         = @"http://itunes.apple.com/lookup?id=%@";
NSString * const HarpyAppStoreLinkCountrySpecific   = @"http://itunes.apple.com/lookup?id=%@&country=%@";

/// i18n/l10n constants
NSString * const HarpyLanguageArabic                = @"ar";
NSString * const HarpyLanguageBasque                = @"eu";
NSString * const HarpyLanguageChineseSimplified     = @"zh-Hans";
NSString * const HarpyLanguageChineseTraditional    = @"zh-Hant";
NSString * const HarpyLanguageDanish                = @"da";
NSString * const HarpyLanguageDutch                 = @"nl";
NSString * const HarpyLanguageEnglish               = @"en";
NSString * const HarpyLanguageEstonian              = @"et";
NSString * const HarpyLanguageFrench                = @"fr";
NSString * const HarpyLanguageGerman                = @"de";
NSString * const HarpyLanguageHebrew                = @"he";
NSString * const HarpyLanguageHungarian             = @"hu";
NSString * const HarpyLanguageItalian               = @"it";
NSString * const HarpyLanguageJapanese              = @"ja";
NSString * const HarpyLanguageKorean                = @"ko";
NSString * const HarpyLanguageLithuanian            = @"lt";
NSString * const HarpyLanguageLatvian               = @"lv";
NSString * const HarpyLanguagePolish                = @"pl";
NSString * const HarpyLanguagePortugueseBrazil      = @"pt";
NSString * const HarpyLanguagePortuguesePortugal    = @"pt-PT";
NSString * const HarpyLanguageRussian               = @"ru";
NSString * const HarpyLanguageSlovenian             = @"sl";
NSString * const HarpyLanguageSwedish               = @"sv";
NSString * const HarpyLanguageSpanish               = @"es";
NSString * const HarpyLanguageThai                  = @"th";
NSString * const HarpyLanguageTurkish               = @"tr";

@interface Harpy() <UIAlertViewDelegate>

@property (nonatomic, strong) NSDictionary *appData;
@property (nonatomic, strong) NSDate *lastVersionCheckPerformedOnDate;
@property (nonatomic, copy) NSString *currentAppStoreVersion;
@property (nonatomic, copy) NSString *updateAvailableMessage;
@property (nonatomic, copy) NSString *theNewVersionMessage;
@property (nonatomic, copy) NSString *updateButtonText;
@property (nonatomic, copy) NSString *nextTimeButtonText;
@property (nonatomic, copy) NSString *skipButtonText;

@end

@implementation Harpy

#pragma mark - Initialization
+ (Harpy *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _alertType = HarpyAlertTypeOption;
        _lastVersionCheckPerformedOnDate = [[NSUserDefaults standardUserDefaults] objectForKey:HarpyDefaultStoredVersionCheckDate];
    }
    return self;
}

#pragma mark - Public
- (void)checkVersion
{
    if (!_appID || !_presentingViewController) {
       
        NSLog(@"[Harpy]: Please make sure that you have set _appID and _presentationViewController before calling checkVersion, checkVersionDaily, or checkVersionWeekly");
    
    } else {
        [self performVersionCheck];
    }
}

- (void)checkVersionDaily
{
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
    if ([self numberOfDaysElapsedBetweenLastVersionCheckDate] > 1) {
        [self checkVersion];
    }
}

- (void)checkVersionWeekly
{
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
    if ([self numberOfDaysElapsedBetweenLastVersionCheckDate] > 7) {
        [self checkVersion];
    }
}

#pragma mark - Private
- (void)performVersionCheck
{
    // Create storeString for iTunes Lookup API request
    NSString *storeString = nil;
    if ([self countryCode]) {
        storeString = [NSString stringWithFormat:HarpyAppStoreLinkCountrySpecific, _appID, _countryCode];
    } else {
        storeString = [NSString stringWithFormat:HarpyAppStoreLinkUniversal, _appID];
    }
    
    // Initialize storeURL with storeString, and create request object
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:storeURL];
    [request setHTTPMethod:@"GET"];

    if ([self isDebugEnabled]) {
        NSLog(@"[Harpy] storeURL: %@", storeURL);
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if ([data length] > 0 && !error) { // Success
            
                                                    self.appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
                                                    if ([self isDebugEnabled]) {
                                                        NSLog(@"[Harpy] JSON Results: %@", _appData);
                                                    }
            
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                
                                                        // Store version comparison date
                                                        self.lastVersionCheckPerformedOnDate = [NSDate date];
                                                        [[NSUserDefaults standardUserDefaults] setObject:[self lastVersionCheckPerformedOnDate] forKey:HarpyDefaultStoredVersionCheckDate];
                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                
                                                        /**
                                                         Current version that has been uploaded to the AppStore.
                                                         Used to contain all versions, but now only contains the latest version.
                                                         Still returns an instance of NSArray.
                                                         */
                                                        NSArray *versionsInAppStore = [[self.appData valueForKey:@"results"] valueForKey:@"version"];
                
                                                        if ([versionsInAppStore count]) {
                                                            _currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                                                            [self checkIfAppStoreVersionIsNewestVersion:_currentAppStoreVersion];
                                                        }
                                                    });
                                                }
                                            }];
    [task resume];
}

- (NSUInteger)numberOfDaysElapsedBetweenLastVersionCheckDate
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitDay
                                                      fromDate:[self lastVersionCheckPerformedOnDate]
                                                        toDate:[NSDate date]
                                                       options:0];
    return [components day];
}

- (void)checkIfAppStoreVersionIsNewestVersion:(NSString *)currentAppStoreVersion
{
    // Current installed version is the newest public version or newer (e.g., dev version)
    if ([[self currentVersion] compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
        [self localizeAlertStringsForCurrentAppStoreVersion:currentAppStoreVersion];
        [self alertTypeForVersion:currentAppStoreVersion];
        [self showAlertIfCurrentAppStoreVersionNotSkipped:currentAppStoreVersion];
    }
}

- (void)showAlertIfCurrentAppStoreVersionNotSkipped:(NSString *)currentAppStoreVersion
{
    // Check if user decided to skip this version in the past
    NSString *storedSkippedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:HarpyDefaultSkippedVersion];
    
    if (![storedSkippedVersion isEqualToString:currentAppStoreVersion]) {
        [self showAlertWithAppStoreVersion:currentAppStoreVersion];
    } else {
        // Don't show alert.
        return;
    }
}

- (void)localizeAlertStringsForCurrentAppStoreVersion:(NSString *)currentAppStoreVersion
{
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

- (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    // Initialize UIAlertView & UIAlertController
    UIAlertView *alertView;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_updateAvailableMessage
                                                                             message:_theNewVersionMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    if (_alertControllerTintColor) {
        [alertController.view setTintColor:_alertControllerTintColor];
    }
    
    // Get current version
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSUInteger currentOSVersion = [[versionCompatibility objectAtIndex:0] integerValue];
    
    // Show Appropriate UIAlertView
    switch ([self alertType]) {
            
        case HarpyAlertTypeForce: {
            
            if (currentOSVersion > 7) {
                
                [alertController addAction:[self updateAlertAction]];
                
                if (_presentingViewController != nil) {
                    [_presentingViewController presentViewController:alertController animated:YES completion:nil];
                }
                
            } else {
                
                alertView = [[UIAlertView alloc] initWithTitle:_updateAvailableMessage
                                                       message:_theNewVersionMessage
                                                      delegate:self
                                             cancelButtonTitle:_updateButtonText
                                             otherButtonTitles:nil, nil];
            }
            
        } break;
            
        case HarpyAlertTypeOption: {
            
            if (currentOSVersion > 7) {
                
                [alertController addAction:[self nextTimeAlertAction]];
                [alertController addAction:[self updateAlertAction]];
                
                if (_presentingViewController != nil) {
                    [_presentingViewController presentViewController:alertController animated:YES completion:nil];
                }
                
            } else {
                
                alertView = [[UIAlertView alloc] initWithTitle:_updateAvailableMessage
                                                       message:_theNewVersionMessage
                                                      delegate:self
                                             cancelButtonTitle:_nextTimeButtonText
                                             otherButtonTitles:_updateButtonText, nil];
            }
            
        } break;
            
        case HarpyAlertTypeSkip: {
            
            if (currentOSVersion > 7) {
            
                [alertController addAction:[self skipAlertAction]];
                [alertController addAction:[self nextTimeAlertAction]];
                [alertController addAction:[self updateAlertAction]];
                
                if (_presentingViewController != nil) {
                    [_presentingViewController presentViewController:alertController animated:YES completion:nil];
                }
                

            } else {
                
                alertView = [[UIAlertView alloc] initWithTitle:_updateAvailableMessage
                                                       message:_theNewVersionMessage
                                                      delegate:self
                                             cancelButtonTitle:_updateButtonText
                                             otherButtonTitles:_skipButtonText, _nextTimeButtonText, nil];
            }
            
        } break;

        case HarpyAlertTypeNone: { // Do Nothing
        } break;
    }
    
    [alertView show];

    if([self.delegate respondsToSelector:@selector(harpyDidShowUpdateDialog)]){
        [self.delegate harpyDidShowUpdateDialog];
    }
}

- (void)launchAppStore
{
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", [self appID]];
    NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
    [[UIApplication sharedApplication] openURL:iTunesURL];

    if([self.delegate respondsToSelector:@selector(harpyUserDidLaunchAppStore)]){
        [self.delegate harpyUserDidLaunchAppStore];
    }
}

- (void)alertTypeForVersion:(NSString *)currentAppStoreVersion
{
    // Check what version the update is, major, minor or a patch
    NSArray *oldVersionComponents = [[self currentVersion] componentsSeparatedByString:@"."];
    NSArray *newVersionComponents = [currentAppStoreVersion componentsSeparatedByString: @"."];
    
    if ([oldVersionComponents count] == 3 && [newVersionComponents count] == 3) {
        if ([newVersionComponents[0] integerValue] > [oldVersionComponents[0] integerValue]) { // A.b.c
            if (_majorUpdateAlertType) _alertType = _majorUpdateAlertType;
        } else if ([newVersionComponents[1] integerValue] > [oldVersionComponents[1] integerValue]) { // a.B.c
            if (_minorUpdateAlertType) _alertType = _minorUpdateAlertType;
        } else if ([newVersionComponents[2] integerValue] > [oldVersionComponents[2] integerValue]) { // a.b.C
           if (_patchUpdateAlertType) _alertType = _patchUpdateAlertType;
        }
    }
}

#pragma mark - NSBundle Strings
- (NSString *)currentVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)bundlePath
{
    return [[NSBundle mainBundle] pathForResource:@"Harpy" ofType:@"bundle"];
}

- (NSString *)localizedStringForKey:(NSString *)stringKey
{
    return ([[NSBundle mainBundle] pathForResource:@"Harpy" ofType:@"bundle"] ? [[NSBundle bundleWithPath:[self bundlePath]] localizedStringForKey:stringKey value:stringKey table:@"HarpyLocalizable"] : stringKey);
}

- (NSString *)forcedLocalizedStringForKey:(NSString *)stringKey
{
    NSString *path = [[NSBundle bundleWithPath:[self bundlePath]] pathForResource:[self forceLanguageLocalization] ofType:@"lproj"];
    return [[NSBundle bundleWithPath:path] localizedStringForKey:stringKey value:stringKey table:@"HarpyLocalizable"];
}

#pragma mark - UIAlertActions
- (UIAlertAction *)updateAlertAction
{
    UIAlertAction *updateAlertAction = [UIAlertAction actionWithTitle:_updateButtonText
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [self launchAppStore];
                                                              }];
    
    return updateAlertAction;
}

- (UIAlertAction *)nextTimeAlertAction
{
    UIAlertAction *nextTimeAlertAction = [UIAlertAction actionWithTitle:_nextTimeButtonText
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    if([self.delegate respondsToSelector:@selector(harpyUserDidCancel)]){
                                                                        [self.delegate harpyUserDidCancel];
                                                                    }
                                                                }];
    
    return nextTimeAlertAction;
}

- (UIAlertAction *)skipAlertAction
{
    UIAlertAction *skipAlertAction = [UIAlertAction actionWithTitle:_skipButtonText
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                [[NSUserDefaults standardUserDefaults] setObject:_currentAppStoreVersion forKey:HarpyDefaultSkippedVersion];
                                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                                if([self.delegate respondsToSelector:@selector(harpyUserDidSkipVersion)]){
                                                                    [self.delegate harpyUserDidSkipVersion];
                                                                }
                                                            }];
    
    return skipAlertAction;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([self alertType]) {
            
        case HarpyAlertTypeForce: { // Launch App Store.app
            [self launchAppStore];
        } break;
            
        case HarpyAlertTypeOption: {
            
            if (buttonIndex == 1) { // Launch App Store.app
                [self launchAppStore];
            } else { // Ask user on next launch
                if([self.delegate respondsToSelector:@selector(harpyUserDidCancel)]){
                    [self.delegate harpyUserDidCancel];
                }
            }
            
        } break;
            
        case HarpyAlertTypeSkip: {
            
            if (buttonIndex == 0) { // Skip current version in AppStore
                [self launchAppStore];
            } else if (buttonIndex == 1) { // Launch App Store.app
                [[NSUserDefaults standardUserDefaults] setObject:_currentAppStoreVersion forKey:HarpyDefaultSkippedVersion];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if([self.delegate respondsToSelector:@selector(harpyUserDidSkipVersion)]){
                    [self.delegate harpyUserDidSkipVersion];
                }
            } else if (buttonIndex == 2) { // Ask user on next launch
                if([self.delegate respondsToSelector:@selector(harpyUserDidCancel)]){
                    [self.delegate harpyUserDidCancel];
                }
            }
        } break;

        case HarpyAlertTypeNone: {
            // Do nothing
        } break;
    }
}

@end
