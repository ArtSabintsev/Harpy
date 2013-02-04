//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"
#import "HarpyConstants.h"
#import "VersionComparator.h"

#define kHarpyCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]
#define kHarpyIgnoreUpdateKey @"HarpyIgnoreUpdateKey"

@interface Harpy ()

+ (void)showAlertWithAppStoreVersion:(NSString*)appStoreVersion;

@end

@implementation Harpy

static NSString* currentAppStoreVersion;

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
                
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                    
                    return;
                    
                } else {

                    currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                  
                    // Don't ask again if user ignored previous message
                    if ( [[[NSUserDefaults standardUserDefaults] objectForKey:kHarpyIgnoreUpdateKey] isEqualToString:currentAppStoreVersion] ) {
                        return;
                    }

                    NSString* currentVersion = kHarpyCurrentVersion;
                    if ( [VersionComparator isVersion:currentAppStoreVersion greaterThanVersion:currentVersion] ) {
		                
                        [currentAppStoreVersion retain];
                        [Harpy showAlertWithAppStoreVersion:currentAppStoreVersion];
	                
                    }
                    else {
		            
                        // Current installed version is the newest public version or newer	
	                
                    }

                }
              
            });
        }
        
    }];
}

#pragma mark - Private Methods
+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    if ( harpyForceUpdate ) { // Force user to update app
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:NSLocalizedString(@"A new version of %@ is available. Please update to version %@ now.",@""), appName, currentAppStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyUpdateButtonTitle
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
      
    } else { // Allow user option to update next time user launches your app
              
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:NSLocalizedString(@"A new version of %@ is available. Please update to version %@ now.", @""), appName, currentAppStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyCancelButtonTitle
                                                  otherButtonTitles:kHarpyUpdateButtonTitle, kHarpyIgnoreButtonTitle, nil];
        
        [alertView show];
        
    }
    
}

#pragma mark - UIAlertViewDelegate Methods
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ( harpyForceUpdate ) {

        NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
        NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
        [[UIApplication sharedApplication] openURL:iTunesURL];
        
    } else {

        switch ( buttonIndex ) {
                
            case 0:{ // Cancel / Not now
        
                // Do nothing
                
            } break;
                
            case 1:{ // Update
                
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
                NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:iTunesURL];
                
            } break;
            
            case 2: { // Ignore
                [[NSUserDefaults standardUserDefaults] setObject:currentAppStoreVersion forKey:kHarpyIgnoreUpdateKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } break;
            default:
                break;
        }
        
    }
    [currentAppStoreVersion release];
    currentAppStoreVersion = nil;
}

@end
