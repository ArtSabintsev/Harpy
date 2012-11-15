//
//  Harpy.h
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *appID = @"556665733";
static BOOL forceUpdate = YES;

@interface Harpy : NSObject <UIAlertViewDelegate>

/**
 * Checks the installed version of your application against the version currently available on the iTunes store.
 * If a newer version exists on the store, it prompts the user to update the app.
 */
+ (void)checkVersion;

@end