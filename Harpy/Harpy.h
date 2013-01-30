//
//  Harpy.h
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning Please customize Harpy's static variables

/*
 Option 1: YES forces user to update app on launch. 
 Option 2: NO gives user option to update during next session launch\
*/
static BOOL harpyForceUpdate = NO;

// 2. Your AppID (found in iTunes Connect)
#define kHarpyAppID         @"573293275"


// 3. Customize the alert title and action buttons
#define kHarpyAlertViewTitle      @"Update Available"
#define kHarpyCancelButtonTitle   @"Not now"
#define kHarpyUpdateButtonTitle   @"Update"

@interface Harpy : NSObject <UIAlertViewDelegate>

/*
  Checks the installed version of your application against the version currently available on the iTunes store.
  If a newer version exists in the AppStore, it prompts the user to update your app.
 */
+ (void)checkVersion;

@end