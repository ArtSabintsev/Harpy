//
//  HarpyConstants.h
//  
//
//  Created by Arthur Ariel Sabintsev on 1/30/13.
//
//

#warning Please customize Harpy's static variables

/*
 Option 1 (DEFAULT): NO gives user option to update during next session launch
 Option 2: YES forces user to update app on launch
 */
static BOOL harpyForceUpdate = NO;

// 2. Your AppID (found in iTunes Connect)
#define kHarpyAppID                 @"573293275"

// 3. Customize the alert title and action buttons
#define kHarpyAlertViewTitle        @"Update Available"
#define kHarpyCancelButtonTitle     @"Not now"
#define kHarpyUpdateButtonTitle     @"Update"
