//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"

/// NSUserDefault macros to store user's preferences for HarpyAlertTypeSkip
#define kHarpyDefaultShouldSkipVersion      @"Harpy Should Skip Version Boolean"
#define kHarpyDefaultSkippedVersion         @"Harpy User Decided To Skip Version Update Boolean"

/// i18n/l10n macros
#define kHarpyCurrentVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kHarpyBundle [[NSBundle mainBundle] pathForResource:@"Harpy" ofType:@"bundle"]
#define HarpyLocalizedString(stringKey) \
    [[NSBundle bundleWithPath:kHarpyBundle] localizedStringForKey:stringKey value:stringKey table:@"HarpyLocalizable"]

/// App Store Link
#define kAppStoreLinkUniversal              @"http://itunes.apple.com/lookup?id=%@"
#define kAppStoreLinkCountrySpecific        @"http://itunes.apple.com/lookup?id=%@&country=%@"

@interface Harpy() <UIAlertViewDelegate>

@property (strong, nonatomic) NSDate *lastVersionCheckPerformedOnDate;

- (NSUInteger)numberOfDaysElapsedBetweenILastVersionCheckDate;
- (void)showAlertIfCurrentAppStoreVersionNotSkipped:(NSString *)currentAppStoreVersion;
- (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion;
- (void)launchAppStore;

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
    if ( [self countryCode] ) {
        storeString = [NSString stringWithFormat:kAppStoreLinkCountrySpecific, self.appID, self.countryCode];
    } else {
        storeString = [NSString stringWithFormat:kAppStoreLinkUniversal, self.appID];
    }
    
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Store version comparison date
                self.lastVersionCheckPerformedOnDate = [NSDate date];
                
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                    
                    return;
                    
                } else {
                    
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];

                    if ( [kHarpyCurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending ) {
                        
                        [self showAlertIfCurrentAppStoreVersionNotSkipped:currentAppStoreVersion];
                        
                    } else {
                        
                        // Current installed version is the newest public version or newer (e.g., dev version)	
                        
                    }
                    
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
    if ( !self.lastVersionCheckPerformedOnDate ) {
        
        // Set Initial Date
        self.lastVersionCheckPerformedOnDate = [NSDate date];
        
        // Perform First Launch Check
        [self checkVersion];
        
    }
    
    // If daily condition is satisfied, perform version check
    if ( [self numberOfDaysElapsedBetweenILastVersionCheckDate] > 1 ) {
        
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
    if ( !self.lastVersionCheckPerformedOnDate ) {
        
        // Set Initial Date
        self.lastVersionCheckPerformedOnDate = [NSDate date];
        
        // Perform First Launch Check
        [self checkVersion];
        
    }
    
    // If weekly condition is satisfied, perform version check 
    if ( [self numberOfDaysElapsedBetweenILastVersionCheckDate] > 7 ) {
        
        [self checkVersion];

    }
}

#pragma mark - Private Methods
- (NSUInteger)numberOfDaysElapsedBetweenILastVersionCheckDate
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:kCFCalendarUnitDay
                                                      fromDate:self.lastVersionCheckPerformedOnDate
                                                        toDate:[NSDate date]
                                                       options:0];
    
    return [components day];
}

- (void)showAlertIfCurrentAppStoreVersionNotSkipped:(NSString *)currentAppStoreVersion
{
    // Check if user decided to skip this version in the past
    BOOL shouldSkipVersionUpdate = [[NSUserDefaults standardUserDefaults] boolForKey:kHarpyDefaultShouldSkipVersion];
    NSString *storedSkippedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kHarpyDefaultSkippedVersion];
    
    if ( !shouldSkipVersionUpdate ) {
        
        [self showAlertWithAppStoreVersion:currentAppStoreVersion];
        
    } else if ( shouldSkipVersionUpdate && ![storedSkippedVersion isEqualToString:currentAppStoreVersion] ) {
        
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
    
    switch ( self.alertType ) {
            
        case HarpyAlertTypeForce: {
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:HarpyLocalizedString(@"Update Available")
                                                                message:[NSString stringWithFormat:HarpyLocalizedString(@"A new version of %@ is available. Please update to version %@ now."), appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:HarpyLocalizedString(@"Update")
                                                      otherButtonTitles:nil, nil];
            
            [alertView show];

            
        } break;
            
        case HarpyAlertTypeOption: {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:HarpyLocalizedString(@"Update Available")
                                                                message:[NSString stringWithFormat:HarpyLocalizedString(@"A new version of %@ is available. Please update to version %@ now."), appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:HarpyLocalizedString(@"Next time")
                                                      otherButtonTitles:HarpyLocalizedString(@"Update"), nil];
            
            [alertView show];
            
        } break;
            
        case HarpyAlertTypeSkip: {
            
            // Store currentAppStoreVersion in case user pushes skip
            [[NSUserDefaults standardUserDefaults] setObject:currentAppStoreVersion forKey:kHarpyDefaultSkippedVersion];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:HarpyLocalizedString(@"Update Available")
                                                                message:[NSString stringWithFormat:HarpyLocalizedString(@"A new version of %@ is available. Please update to version %@ now."), appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:HarpyLocalizedString(@"Skip this version")
                                                      otherButtonTitles:HarpyLocalizedString(@"Update"), HarpyLocalizedString(@"Next time"), nil];
            
            [alertView show];
            
        } break;
            
        default:
            break;
    }

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
    switch ( self.alertType ) {
            
        case HarpyAlertTypeForce: { // Launch App Store.app

            [self launchAppStore];

        } break;
            
        case HarpyAlertTypeOption: {
            
            if ( 1 == buttonIndex ) { // Launch App Store.app
                
                [self launchAppStore];
                
            } else { // Ask user on next launch
                
                if([self.delegate respondsToSelector:@selector(harpyUserDidCancel)]){
                    [self.delegate harpyUserDidCancel];
                }
                
            }
            
        } break;
            
        case HarpyAlertTypeSkip: {
            
            if ( 0 == buttonIndex ) { // Skip current version in AppStore
            
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHarpyDefaultShouldSkipVersion];
                [[NSUserDefaults standardUserDefaults] synchronize];

                if([self.delegate respondsToSelector:@selector(harpyUserDidSkipVersion)]){
                    [self.delegate harpyUserDidSkipVersion];
                }
                
            } else if ( 1 == buttonIndex ) { // Launch App Store.app
                
                [self launchAppStore];
                
            } else if ( 2 == buttonIndex) { // Ask user on next launch

                if([self.delegate respondsToSelector:@selector(harpyUserDidCancel)]){
                    [self.delegate harpyUserDidCancel];
                }
                
            }
            
        } break;
            
        default:
            break;
    }
}

@end
