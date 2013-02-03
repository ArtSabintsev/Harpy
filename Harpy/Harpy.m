//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"
#import "HarpyConstants.h"
#import "JSONKit.h"

#define kHarpyCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]


@interface Harpy ()

+ (void)showAlertWithAppStoreVersion:(NSString *)appStoreVersion;

@end


@implementation Harpy

#pragma mark - Public Methods

+ (NSURL *)requestURL
{
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",
                                                       kHarpyAppID];
    return [NSURL URLWithString:storeString];
}

+ (void)checkVersion
{
    NSURL *storeURL = [self requestURL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        NSData *data = [NSData dataWithContentsOfURL:storeURL];
        @try {
            id jsonResult = [data objectFromJSONData];
            if (![jsonResult isKindOfClass:[NSMutableDictionary class]]) {
                return;
            }
            id resultCount = [jsonResult objectForKey:@"resultCount"];
            if (![resultCount isKindOfClass:[NSNumber class]] || ![resultCount intValue]) {
                return;
            }
            id results = [jsonResult objectForKey:@"results"];
            if (![results isKindOfClass:[NSArray class]] || ![results count]) {
                return;
            }
            id latestVersionDescription = [results objectAtIndex:0];
            if (![latestVersionDescription isKindOfClass:[NSMutableDictionary class]]) {
                return;
            }
            id currentAppStoreVersion = [latestVersionDescription objectForKey:@"version"];
            if (![currentAppStoreVersion isKindOfClass:[NSString class]] ||
                    [kHarpyCurrentVersion compare:currentAppStoreVersion
                                          options:NSNumericSearch] != NSOrderedAscending) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [Harpy showAlertWithAppStoreVersion:currentAppStoreVersion];
            });
        }
        @catch (NSException *exception) {
            // Do nothing.
            // JSONKit may have thrown an exception.
        }
    });
}


#pragma mark - Private Methods
+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *) kCFBundleNameKey];
    if (harpyForceUpdate) { // Force user to update app

        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                             message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.",
                                                                                                appName,
                                                                                                currentAppStoreVersion]
                                                            delegate:self
                                                   cancelButtonTitle:kHarpyUpdateButtonTitle
                                                   otherButtonTitles:nil,
                                                                     nil] autorelease];
        [alertView show];
    }
    else { // Allow user option to update next time user launches your app

        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                             message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.",
                                                                                                appName,
                                                                                                currentAppStoreVersion]
                                                            delegate:self
                                                   cancelButtonTitle:kHarpyCancelButtonTitle
                                                   otherButtonTitles:kHarpyUpdateButtonTitle,
                                                                     nil] autorelease];
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate Methods
+ (void)   alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (harpyForceUpdate) {
        [self openITunes];
        return;
    }
    switch (buttonIndex) {
        case 0:  // Cancel / Not now
            // Do nothing
            break;
        case 1:  // Update
            [self openITunes];
            break;
        default:
            break;
    }
}

+ (void)openITunes
{
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",
                                                        kHarpyAppID];
    NSURL    *iTunesURL    = [NSURL URLWithString:iTunesString];
    [[UIApplication sharedApplication] openURL:iTunesURL];
}


@end
