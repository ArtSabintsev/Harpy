//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"
#import "UIDevice+SupportedDevices.h"

/// NSUserDefault macros to store user's preferences for HarpyAlertTypeSkip
#define HARPY_DEFAULT_SHOULD_SKIP_VERSION           @"Harpy Should Skip Version Boolean"
#define HARPY_DEFAULT_SKIPPED_VERSION               @"Harpy User Decided To Skip Version Update Boolean"

/// i18n/l10n macros
#define HARPY_CURRENT_VERSION                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define HARPY_BUNDLE                                [[NSBundle mainBundle] pathForResource:@"Harpy" ofType:@"bundle"]
#define HARPY_LOCALIZED_STRING(stringKey)           [[NSBundle bundleWithPath:HARPY_BUNDLE] localizedStringForKey:stringKey value:stringKey table:@"HarpyLocalizable"]

/// App Store links
#define HARPY_APP_STORE_LINK_UNIVERSAL              @"http://itunes.apple.com/lookup?id=%@"
#define HARPY_APP_STORE_LINK_COUNTRY_SPECIFIC       @"http://itunes.apple.com/lookup?id=%@&country=%@"

/// JSON Parsing
#define HARPY_APP_STORE_RESULTS                     [self.appData valueForKey:@"results"]

@interface Harpy() <UIAlertViewDelegate>

@property (strong, nonatomic) NSDictionary *appData;
@property (strong, nonatomic) NSDate *lastVersionCheckPerformedOnDate;

@end

@implementation Harpy

#pragma mark - Initialization Methods
+ (id)sharedInstance
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
    }
    return self;
}

#pragma mark - Public Methods
- (void)checkVersion
{
    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = nil;
    if ([self countryCode]) {
        storeString = [NSString stringWithFormat:HARPY_APP_STORE_LINK_COUNTRY_SPECIFIC, self.appID, self.countryCode];
    } else {
        storeString = [NSString stringWithFormat:HARPY_APP_STORE_LINK_UNIVERSAL, self.appID];
    }
    
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ([data length] > 0 && !error) { // Success
            
            self.appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Store version comparison date
                self.lastVersionCheckPerformedOnDate = [NSDate date];
                
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [HARPY_APP_STORE_RESULTS valueForKey:@"version"];
                
                if ([versionsInAppStore count]) { // No versions of app in AppStore
                    
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    [self checkIfDeviceIsSupportedInCurrentAppStoreVersion:currentAppStoreVersion];
                    
                }
            });
        }
    }];
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
    if ([self numberOfDaysElapsedBetweenILastVersionCheckDate] > 1) {
        
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
    if ([self numberOfDaysElapsedBetweenILastVersionCheckDate] > 7) {
        [self checkVersion];
    }
}

#pragma mark - Private Methods
- (NSUInteger)numberOfDaysElapsedBetweenILastVersionCheckDate
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitDay
                                                      fromDate:self.lastVersionCheckPerformedOnDate
                                                        toDate:[NSDate date]
                                                       options:0];
    return [components day];
}

- (void)checkIfDeviceIsSupportedInCurrentAppStoreVersion:(NSString *)currentAppStoreVersion
{
    // Current installed version is the newest public version or newer (e.g., dev version)
    if ([HARPY_CURRENT_VERSION compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
        
        /*
         This conditional checks to see if the current device is supported.
         If the current device is supported, or if the current device is one of the simualtors,
         the update notification alert will be presented to the user. However, if the the device is
         not supported, no alert will be shown, as the current version of the app no longer works on the current device.
         */
        
        NSArray *supportedDevices = [HARPY_APP_STORE_RESULTS valueForKey:@"supportedDevices"][0];
        NSString *currentDeviceName = [UIDevice supportedDeviceName];
        
        if ([supportedDevices containsObject:currentDeviceName] ||
            [currentDeviceName isEqualToString:[UIDevice simulatorNamePad]] ||
            [currentDeviceName isEqualToString:[UIDevice simulatorNamePhone]]) {
            [self showAlertIfCurrentAppStoreVersionNotSkipped:currentAppStoreVersion];
        }
    }
}

- (void)showAlertIfCurrentAppStoreVersionNotSkipped:(NSString *)currentAppStoreVersion
{
    // Check if user decided to skip this version in the past
    BOOL shouldSkipVersionUpdate = [[NSUserDefaults standardUserDefaults] boolForKey:HARPY_DEFAULT_SHOULD_SKIP_VERSION];
    NSString *storedSkippedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:HARPY_DEFAULT_SKIPPED_VERSION];
    
    if (!shouldSkipVersionUpdate) {
        [self showAlertWithAppStoreVersion:currentAppStoreVersion];
    } else if (shouldSkipVersionUpdate && ![storedSkippedVersion isEqualToString:currentAppStoreVersion]) {
        [self showAlertWithAppStoreVersion:currentAppStoreVersion];
    } else {
        // Don't show alert.
        return;
    }
}

- (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    // Reference App's name
    NSString *appName = ([self appName]) ? [self appName] : [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    // Initialize UIAlertView
    UIAlertView *alertView;
    
    // Show Appropriate UIAlertView
    switch ([self alertType]) {
            
        case HarpyAlertTypeForce: {
            
            alertView = [[UIAlertView alloc] initWithTitle:HARPY_LOCALIZED_STRING(@"Update Available")
                                                                message:[NSString stringWithFormat:HARPY_LOCALIZED_STRING(@"A new version of %@ is available. Please update to version %@ now."), appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:HARPY_LOCALIZED_STRING(@"Update")
                                                      otherButtonTitles:nil, nil];
            
        } break;
            
        case HarpyAlertTypeOption: {
            
           alertView = [[UIAlertView alloc] initWithTitle:HARPY_LOCALIZED_STRING(@"Update Available")
                                                                message:[NSString stringWithFormat:HARPY_LOCALIZED_STRING(@"A new version of %@ is available. Please update to version %@ now."), appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:HARPY_LOCALIZED_STRING(@"Next time")
                                                      otherButtonTitles:HARPY_LOCALIZED_STRING(@"Update"), nil];
            
        } break;
            
        case HarpyAlertTypeSkip: {
            
            // Store currentAppStoreVersion in case user pushes skip
            [[NSUserDefaults standardUserDefaults] setObject:currentAppStoreVersion forKey:HARPY_DEFAULT_SKIPPED_VERSION];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            alertView = [[UIAlertView alloc] initWithTitle:HARPY_LOCALIZED_STRING(@"Update Available")
                                                                message:[NSString stringWithFormat:HARPY_LOCALIZED_STRING(@"A new version of %@ is available. Please update to version %@ now."), appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:HARPY_LOCALIZED_STRING(@"Skip this version")
                                                      otherButtonTitles:HARPY_LOCALIZED_STRING(@"Update"), HARPY_LOCALIZED_STRING(@"Next time"), nil];
            
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

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([self alertType]) {
            
        case HarpyAlertTypeForce: { // Launch App Store.app

            [self launchAppStore];

        } break;
            
        case HarpyAlertTypeOption: {
            
            if (1 == buttonIndex) { // Launch App Store.app
                [self launchAppStore];
            } else { // Ask user on next launch
                if([self.delegate respondsToSelector:@selector(harpyUserDidCancel)]){
                    [self.delegate harpyUserDidCancel];
                }
            }
            
        } break;
            
        case HarpyAlertTypeSkip: {
            
            if (0 == buttonIndex) { // Skip current version in AppStore
            
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HARPY_DEFAULT_SHOULD_SKIP_VERSION];
                [[NSUserDefaults standardUserDefaults] synchronize];

                if([self.delegate respondsToSelector:@selector(harpyUserDidSkipVersion)]){
                    [self.delegate harpyUserDidSkipVersion];
                }
                
            } else if (1 == buttonIndex) { // Launch App Store.app
                [self launchAppStore];
            } else if (2 == buttonIndex) { // Ask user on next launch
                if([self.delegate respondsToSelector:@selector(harpyUserDidCancel)]){
                    [self.delegate harpyUserDidCancel];
                }
            }
        } break;
    }
}

@end
