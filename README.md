# Harpy
### Notify users when a new version of your app is available, and prompt them with the App Store link.

---
### About
**Harpy** checks a user's currently installed version of your iOS app against the version that is currently available in the App Store. If a new version is available, an alert can be presented to the user informing them of the newer version, and giving them the option to update the application.

This library is built to work with the [Semantic Versioning](http://semver.org/) system.

### Swift Support
Harpy has been ported to Swift by myself and [**Aaron Brager**](http://twitter.com/GetAaron). We've called the new project [**Siren**](https://github.com/ArtSabintsev/Siren) and it can be found [here](https://github.com/ArtSabintsev/Siren).

### Changelog
#### 3.4.0
- Added new delegate method to present update message via custom UI.
- Added Sample Project
- Dropped iOS 7 Support
- Cleaned up codebase
- Cleaned up README

### Features
- [x] CocoaPods Support
- [x] Three types of alerts (see **Screenshots & Alert Types**)
- [x] Optional delegate methods (see **Optional Delegate** section)
- [x] Localized for 20+ languages

### Screenshots

- The **left picture** forces the user to update the app.
- The **center picture** gives the user the option to update the app.
- The **right picture** gives the user the option to skip the current update.
- These options are controlled by the `HarpyAlertType` typede that is found in `Harpy.h`.

![Forced Update](https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picForcedUpdate.png?raw=true "Forced Update")
![Optional Update](https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picOptionalUpdate.png?raw=true "Optional Update")
![Skipped Update](https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picSkippedUpdate.png?raw=true "Optional Update")

### Installation Instructions

#### CocoaPods Installation
```
pod 'Harpy'
```

#### Manual Installation

Copy the 'Harpy' folder into your Xcode project. It contains the Harpy.h and Harpy.m files.
### Setup Instructions
1. Import **Harpy.h** into your AppDelegate or Pre-Compiler Header (.pch)
1. In your `AppDelegate`, set the **appID**, and optionally, you can set the **alertType**.
1. In your `AppDelegate`, call **only one** of the `checkVersion` methods, as all three perform a check on your application's first launch. Use either:
    - `checkVersion` in `application:didFinishLaunchingWithOptions:`
    - `checkVersionDaily` in `applicationDidBecomeActive:`.
    - `checkVersionWeekly` in `applicationDidBecomeActive:`.


``` obj-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	// Present Window before calling Harpy
	[self.window makeKeyAndVisible];

	// Set the App ID for your app
	[[Harpy sharedInstance] setAppID:@"<#app_id#>"];

	// Set the UIViewController that will present an instance of UIAlertController
	[[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];

	// (Optional) The tintColor for the alertController
	[[Harpy sharedInstance] setAlertControllerTintColor:@"<#alert_controller_tint_color#>"];

	// (Optional) Set the App Name for your app
	[[Harpy sharedInstance] setAppName:@"<#app_name#>"];

	/* (Optional) Set the Alert Type for your app
	 By default, Harpy is configured to use HarpyAlertTypeOption */
	[[Harpy sharedInstance] setAlertType:<#alert_type#>];

	/* (Optional) If your application is not available in the U.S. App Store, you must specify the two-letter
	 country code for the region in which your applicaiton is available. */
	[[Harpy sharedInstance] setCountryCode:@"<#country_code#>"];

	/* (Optional) Overides system language to predefined language.
	 Please use the HarpyLanguage constants defined in Harpy.h. */
	[[Harpy sharedInstance] setForceLanguageLocalization:<#HarpyLanguageConstant#>];

	// Perform check for new version of your app
	[[Harpy sharedInstance] checkVersion];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

	/*
	 Perform daily check for new version of your app
	 Useful if user returns to you app from background after extended period of time
 	 Place in applicationDidBecomeActive:

 	 Also, performs version check on first launch.
 	*/
	[[Harpy sharedInstance] checkVersionDaily];

	/*
	 Perform weekly check for new version of your app
	 Useful if you user returns to your app from background after extended period of time
	 Place in applicationDidBecomeActive:

	 Also, performs version check on first launch.
	 */
	[[Harpy sharedInstance] checkVersionWeekly];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Perform check for new version of your app
	 Useful if user returns to you app from background after being sent tot he App Store,
	 but doesn't update their app before coming back to your app.

 	 ONLY USE THIS IF YOU ARE USING *HarpyAlertTypeForce*

 	 Also, performs version check on first launch.
 	*/
	[[Harpy sharedInstance] checkVersion];
}

```

And you're all set!

### Differentiated Alerts for Patch, Minor, and Major Updates
If you would like to set a different type of alert for patch, minor, and/or major updates, simply add one or all of the following *optional* lines to your setup *before* calling any of the `checkVersion` methods:

``` obj-c
	/* By default, Harpy is configured to use HarpyAlertTypeOption for all version updates */
	[[Harpy sharedInstance] setPatchUpdateAlertType:<#alert_type#>];
	[[Harpy sharedInstance] setMinorUpdateAlertType:<#alert_type#>];
	[[Harpy sharedInstance] setMajorUpdateAlertType:<#alert_type#>];
```

### Optional Delegate and Delegate Methods
If you'd like to handle or track the end-user's behavior, four delegate methods have been made available to you:

```	obj-c
	// User presented with update dialog
	- (void)harpyDidShowUpdateDialog;

	// User did click on button that launched App Store.app
	- (void)harpyUserDidLaunchAppStore;

	// User did click on button that skips version update
	- (void)harpyUserDidSkipVersion;

	// User did click on button that cancels update dialog
	- (void)harpyUserDidCancel;
```

If you would like to use your own UI, please use the following delegate method to obtain the localized update message if a new version is available:

``` obj-c
- (void)harpyDidDetectNewVersionWithoutAlert:(NSString *)message;
```

### Force Localization
Harpy has localizations for Arabic, Basque, Chinese (Simplified), Chinese (Traditional), Danish, Dutch, English, Estonian, French, German, Hebrew, Hungarian, Italian, Japanese, Korean, Latvian, Lithuanian, Polish, Portuguese (Brazil), Portuguese (Portugal), Russian, Slovenian, Swedish, Spanish, Thai, and Turkish.

You may want the update dialog to *always* appear in a certain language, ignoring iOS's language setting (e.g. apps released in a specific country).

You can enable it like this:

``` obj-c
[[Harpy sharedInstance] setForceLanguageLocalization<#HarpyLanguageConstant#>];
```

### Important Note on App Store Submissions
The App Store reviewer will **not** see the alert.

### Created and maintained by
[Arthur Ariel Sabintsev](http://www.sabintsev.com/)
