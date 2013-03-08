//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"

/// NSUserDefault Macro to store user's preferences for AlertType_Skip
#define kHarpyDefaultShouldSkipVersion      @"Harpy Should Skip Version Boolean"
#define kHarpyDefaultSkippedVersion         @"Harpy User Decided To Skip Version Update Boolean"

/// 3. Customize the alert title and action buttons
#define kHarpyAlertViewTitle                @"Update Available"
#define kHarpyCancelButtonTitle             @"Next time"
#define kHarpySkipButtonTitle               @"Skip this version"
#define kHarpyUpdateButtonTitle             @"Update"

#define kHarpyCurrentVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

@interface Harpy()
<UIAlertViewDelegate>
@property (strong, nonatomic) NSDate *lastVersionCheckPerformedOnDate;
@end

@implementation Harpy

+ (id)sharedInstance{
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
        self.alertType = HarpyAlertTypeOption;
    }
    return self;
}

#pragma mark - Public Methods
- (void)checkVersion
{
    
    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", self.appID];
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
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    switch ( self.alertType ) {
            
        case HarpyAlertTypeForce: {
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                                message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.", appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:kHarpyUpdateButtonTitle
                                                      otherButtonTitles:nil, nil];
            
            [alertView show];

            
        } break;
            
        case HarpyAlertTypeOption: {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                                message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.", appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:kHarpyCancelButtonTitle
                                                      otherButtonTitles:kHarpyUpdateButtonTitle, nil];
            
            [alertView show];
            
        } break;
            
        case HarpyAlertTypeSkip: {
            
            // Store currentAppStoreVersion in case user pushes skip
            [[NSUserDefaults standardUserDefaults] setObject:currentAppStoreVersion forKey:kHarpyDefaultSkippedVersion];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                                message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.", appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:kHarpySkipButtonTitle
                                                      otherButtonTitles:kHarpyUpdateButtonTitle, kHarpyCancelButtonTitle, nil];
            
            [alertView show];
            
        } break;
            
        default:
            break;
    }
    
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    switch ( self.alertType ) {
            
        case HarpyAlertTypeForce: { // Launch App Store.app
            
            NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", self.appID];
            NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
            [[UIApplication sharedApplication] openURL:iTunesURL];
            
        } break;
            
        case HarpyAlertTypeOption: {
            
            if ( 1 == buttonIndex ) { // Launch App Store.app
                
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", self.appID];
                NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:iTunesURL];
                
            } else { // Ask user on next launch
                
                // Do nothing
                
            }
            
        } break;
            
        case HarpyAlertTypeSkip: {
            
            if ( 0 == buttonIndex ) { // Skip current version in AppStore
            
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHarpyDefaultShouldSkipVersion];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } else if ( 1 == buttonIndex ) { // Launch App Store.app
                
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", self.appID];
                NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:iTunesURL];
                
            } else if ( 2 == buttonIndex) { // Ask user on next launch
                
                // Do nothing
                
            }
            
        } break;
            
        default:
            break;
    }
    

    
}

@end
