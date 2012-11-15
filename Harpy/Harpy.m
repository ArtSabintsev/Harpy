//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"

@interface Harpy ()

+ (void)showAlertWithAppStoreVersion:(NSString*)appStoreVersion;

@end

@implementation Harpy

// Public Methods
+ (void)checkVersion
{

    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       
        if ( [data length] > 0 && error == nil ) {
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

            dispatch_async(dispatch_get_main_queue(), ^{
            
                // AppStore version
                NSString *appStoreVersion = [[[appData valueForKey:@"results"] valueForKey:@"version"] objectAtIndex:0];
                
                // Installed version
                NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
                
                if ( ![currentVersion isEqualToString:appStoreVersion] ) {
                    
                    [Harpy showAlertWithAppStoreVersion:appStoreVersion];
                    
                }
                
            });

        }
        
    }];

}


// Private Methods
+ (void)showAlertWithAppStoreVersion:(NSString *)appStoreVersion
{
 
    // App name
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    if ( forceUpdate ) { // Force user to update app
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Update Available"
                                                            message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.", appName, appStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:@"Update"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        
    } else { // Allow user option to update next time user launches your app

        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Update Available"
                                                            message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@.", appName, appStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:@"Not now"
                                                  otherButtonTitles:@"Update", nil];
        
        [alertView show];
        
    }

}

#pragma mark - UIAlertViewDelegate Methods
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ( forceUpdate ) {

        NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", appID];
        NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
        [[UIApplication sharedApplication] openURL:iTunesURL];
        
    } else {

        switch (buttonIndex) {
                
            case 0:{ // Cancel / Not now
        
                // Do nothing
                
            } break;
                
            case 1:{ // Update
                
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", appID];
                NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:iTunesURL];
                
            } break;
                
            default:
                break;
        }
        
    }

    
}

@end