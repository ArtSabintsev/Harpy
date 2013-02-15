//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"
#import "HarpyConstants.h"

#define kHarpyCurrentVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

static NSDate *lastVersionCheckPerformedOnDate;

@interface Harpy ()

+ (NSUInteger)numberOfDaysElapsedBetweenILastVersionCheckDate;
+ (void)showAlertIfCurrentAppStoreVersionNotSkipped:(NSString*)currentAppStoreVersion;
+ (void)showAlertWithAppStoreVersion:(NSString*)appStoreVersion;

@end

@implementation Harpy

#pragma mark - Public Methods
+ (void)checkVersion
{
    
    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kHarpyAppID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Store version comparison date
                lastVersionCheckPerformedOnDate = [NSDate date];
                
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

+ (void)checkVersionDaily
{
    
    /*
     On app's first launch, lastVersionCheckPerformedOnDate isn't set.
     Avoid false-positive fulfilment of second condition in this method.
     Also, performs version check on first launch.
     */
    if ( !lastVersionCheckPerformedOnDate ) {
        
        // Set Initial Date
        lastVersionCheckPerformedOnDate = [NSDate date];
        
        // Perform First Launch Check
        [Harpy checkVersion];
        
    }
    
    // If daily condition is satisfied, perform version check
    if ( [Harpy numberOfDaysElapsedBetweenILastVersionCheckDate] > 1 ) {
        
        [Harpy checkVersion];
        
    }
}

+ (void)checkVersionWeekly
{
    
    /*
     On app's first launch, lastVersionCheckPerformedOnDate isn't set.
     Avoid false-positive fulfilment of second condition in this method.
     Also, performs version check on first launch.
     */
    if ( !lastVersionCheckPerformedOnDate ) {
        
        // Set Initial Date
        lastVersionCheckPerformedOnDate = [NSDate date];
        
        // Perform First Launch Check
        [Harpy checkVersion];
        
    }
    
    // If weekly condition is satisfied, perform version check 
    if ( [Harpy numberOfDaysElapsedBetweenILastVersionCheckDate] > 7 ) {
        
        [Harpy checkVersion];

    }
}

#pragma mark - Private Methods
+ (NSUInteger)numberOfDaysElapsedBetweenILastVersionCheckDate
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:kCFCalendarUnitDay
                                                      fromDate:lastVersionCheckPerformedOnDate
                                                        toDate:[NSDate date]
                                                       options:0];
    
    return [components day];
}

+ (void)showAlertIfCurrentAppStoreVersionNotSkipped:(NSString *)currentAppStoreVersion
{
    // Check if user decided to skip this version in the past
    BOOL shouldSkipVersionUpdate = [[NSUserDefaults standardUserDefaults] boolForKey:kHarpyDefaultShouldSkipVersion];
    NSString *storedSkippedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kHarpyDefaultSkippedVersion];
    
    if ( !shouldSkipVersionUpdate ) {
        
        [Harpy showAlertWithAppStoreVersion:currentAppStoreVersion];
        
    } else if ( shouldSkipVersionUpdate && ![storedSkippedVersion isEqualToString:currentAppStoreVersion] ) {
        
        [Harpy showAlertWithAppStoreVersion:currentAppStoreVersion];
        
    } else {
        
        // Don't show alert.
        return;
        
    }
}

+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    
    // Reference App's name
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    switch ( kHarpyAlertType ) {
            
        case AlertType_Force: {
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                                message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.", appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:kHarpyUpdateButtonTitle
                                                      otherButtonTitles:nil, nil];
            
            [alertView show];

            
        } break;
            
        case AlertType_Option: {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                                message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.", appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:kHarpyCancelButtonTitle
                                                      otherButtonTitles:kHarpyUpdateButtonTitle, nil];
            
            [alertView show];
            
        } break;
            
        case AlertType_Skip: {
            
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
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    switch ( kHarpyAlertType ) {
            
        case AlertType_Force: { // Launch App Store.app
            
            NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
            NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
            [[UIApplication sharedApplication] openURL:iTunesURL];
            
        } break;
            
        case AlertType_Option: {
            
            if ( 1 == buttonIndex ) { // Launch App Store.app
                
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
                NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:iTunesURL];
                
            } else { // Ask user on next launch
                
                // Do nothing
                
            }
            
        } break;
            
        case AlertType_Skip: {
            
            if ( 0 == buttonIndex ) { // Skip current version in AppStore
            
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHarpyDefaultShouldSkipVersion];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } else if ( 1 == buttonIndex ) { // Launch App Store.app
                
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
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
