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
NSString * const HarpyLanguageArmenian              = @"hy";
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
NSString * const HarpyLanguageLatvian               = @"lv";
NSString * const HarpyLanguageLithuanian            = @"lt";
NSString * const HarpyLanguageMalay                 = @"ms";
NSString * const HarpyLanguagePolish                = @"pl";
NSString * const HarpyLanguagePortugueseBrazil      = @"pt";
NSString * const HarpyLanguagePortuguesePortugal    = @"pt-PT";
NSString * const HarpyLanguageRussian               = @"ru";
NSString * const HarpyLanguageSlovenian             = @"sl";
NSString * const HarpyLanguageSwedish               = @"sv";
NSString * const HarpyLanguageSpanish               = @"es";
NSString * const HarpyLanguageThai                  = @"th";
NSString * const HarpyLanguageTurkish               = @"tr";

/// define low version
static const CGFloat kLowVersionNum = 7.0f;
typedef void (^HarpyActionBlockTpye)(void);

@interface Harpy()<UIAlertViewDelegate>

@property (nonatomic, strong) NSDictionary *appData;
@property (nonatomic, strong) NSDate *lastVersionCheckPerformedOnDate;
@property (nonatomic, copy) NSString *currentAppStoreVersion;
@property (nonatomic, copy) NSString *updateAvailableMessage;
@property (nonatomic, copy) NSString *theNewVersionMessage;
@property (nonatomic, copy) NSString *updateButtonText;
@property (nonatomic, copy) NSString *nextTimeButtonText;
@property (nonatomic, copy) NSString *skipButtonText;
@property (nonatomic, strong) NSMutableDictionary *alertViewActions; // support low version

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
- (UIAlertView *)createAlertView
{
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_updateAvailableMessage message:_theNewVersionMessage delegate:self cancelButtonTitle:@"更新0" otherButtonTitles: nil];
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = _updateAvailableMessage;
    alertView.message = _theNewVersionMessage;
//    [alertView addButtonWithTitle:@"更新0"];
//    [alertView addButtonWithTitle:@"hahah1"];
//    [alertView addButtonWithTitle:@"hahah2"];
    
    if (_alertControllerTintColor) {
        [alertView setTintColor:_alertControllerTintColor];
    }
    
    return alertView;
}

- (UIAlertController *)createAlertController
{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_updateAvailableMessage
                                                                             message:_theNewVersionMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    if (_alertControllerTintColor) {
        [alertController.view setTintColor:_alertControllerTintColor];
    }

    return alertController;
}

- (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    // Get System Version
    CGFloat systemVersion = [self systemVersion];
    
    // Show Appropriate UIAlertView
    switch ([self alertType]) {
            
        case HarpyAlertTypeForce: {
            /** Low Version Support */
            if (systemVersion <= kLowVersionNum) {
                UIAlertView *alertView = [self createAlertView];
                [self updateAlertViewActionWithAlertView:alertView];
                [alertView show];
                return;
            } else {
                UIAlertController *alertController = [self createAlertController];
                [alertController addAction:[self updateAlertAction]];
                
                if (_presentingViewController != nil) {
                    [_presentingViewController presentViewController:alertController animated:YES completion:nil];
                }
            }
            

            if([self.delegate respondsToSelector:@selector(harpyDidShowUpdateDialog)]){
                [self.delegate harpyDidShowUpdateDialog];
            }
            
        } break;
            
        case HarpyAlertTypeOption: {
            if (systemVersion <= kLowVersionNum) {
                UIAlertView *alertView = [self createAlertView];
                [self nextTimeAlertViewActionWithAlertView:alertView];
                [self updateAlertViewActionWithAlertView:alertView];
                [alertView show];
                return;
            } else {
                UIAlertController *alertController = [self createAlertController];
                [alertController addAction:[self nextTimeAlertAction]];
                [alertController addAction:[self updateAlertAction]];
                
                if (_presentingViewController != nil) {
                    [_presentingViewController presentViewController:alertController animated:YES completion:nil];
                }
            }

            if([self.delegate respondsToSelector:@selector(harpyDidShowUpdateDialog)]){
                [self.delegate harpyDidShowUpdateDialog];
            }
            
        } break;
            
        case HarpyAlertTypeSkip: {
            if (systemVersion <= kLowVersionNum) {
                UIAlertView *alertView = [self createAlertView];
                [self skipAlertViewActionWithAlertView:alertView];
                [self nextTimeAlertViewActionWithAlertView:alertView];
                [self updateAlertViewActionWithAlertView:alertView];
                [alertView show];
                return;
            } else {
                UIAlertController *alertController = [self createAlertController];
                [alertController addAction:[self skipAlertAction]];
                [alertController addAction:[self nextTimeAlertAction]];
                [alertController addAction:[self updateAlertAction]];
                
                if (_presentingViewController != nil) {
                    [_presentingViewController presentViewController:alertController animated:YES completion:nil];
                }
            }

            if([self.delegate respondsToSelector:@selector(harpyDidShowUpdateDialog)]){
                [self.delegate harpyDidShowUpdateDialog];
            }

        } break;

        case HarpyAlertTypeNone: { //If the delegate is set, pass a localized update message. Otherwise, do nothing.
            if ([self.delegate respondsToSelector:@selector(harpyDidDetectNewVersionWithoutAlert:)]) {
                [self.delegate harpyDidDetectNewVersionWithoutAlert:_theNewVersionMessage];
            }
        } break;
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
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *actionKey = [alertView buttonTitleAtIndex:buttonIndex];
    HarpyActionBlockTpye block = [self.alertViewActions objectForKey:actionKey];
    if (block) {
        block();
    }
}

#pragma mark - UIAlertViewActions(<iOS8)
- (void)configAlertView:(UIAlertView *)alertView Title:(NSString *) title Action:(void (^)())actionBlock {
    [alertView addButtonWithTitle:title];
    self.alertViewActions[title] = [actionBlock copy];
}
- (void)updateAlertViewActionWithAlertView:(UIAlertView *)alertView {
    [self configAlertView:alertView Title:_updateButtonText Action:^{
        [self launchAppStore];
    }];
}
- (void)nextTimeAlertViewActionWithAlertView:(UIAlertView *)alertView{
    [self configAlertView:alertView Title:_nextTimeButtonText Action:^{
        if([self.delegate respondsToSelector:@selector(harpyUserDidCancel)]){
            [self.delegate harpyUserDidCancel];
        }
    }];
}
- (void)skipAlertViewActionWithAlertView:(UIAlertView *)alertView{
    [self configAlertView:alertView Title:_skipButtonText Action:^{
        [[NSUserDefaults standardUserDefaults] setObject:_currentAppStoreVersion forKey:HarpyDefaultSkippedVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([self.delegate respondsToSelector:@selector(harpyUserDidSkipVersion)]){
            [self.delegate harpyUserDidSkipVersion];
        }
    }];
}
#pragma mark - UIAlertViewControllerActions
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

- (NSMutableDictionary *)alertViewActions
{
    if (_alertViewActions == nil) {
        _alertViewActions = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return _alertViewActions;
}

- (CGFloat)systemVersion
{
    static float systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    });
    return systemVersion;
}
@end
