# Harpy
### Notify users when a new version of your app is available and prompt them to upgrade.

[![Build Status](https://travis-ci.org/ArtSabintsev/Harpy.svg?branch=master)](https://travis-ci.org/ArtSabintsev/Harpy)

[![CocoaPods](https://img.shields.io/cocoapods/v/Harpy.svg)](https://cocoapods.org/pods/Harpy)  [![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![CocoaPods](https://img.shields.io/cocoapods/dt/Harpy.svg)](https://cocoapods.org/pods/Harpy) [![CocoaPods](https://img.shields.io/cocoapods/dm/Harpy.svg)](https://cocoapods.org/pods/Harpy)
---

## About
**Harpy** checks a user's currently installed version of your iOS app against the version that is currently available in the App Store. If a new version is available, an alert can be presented to the user informing them of the newer version, and giving them the option to update the application.

Harpy is built to work with the [Semantic Versioning](http://www.semver.org) system.
- Semantic Versioning is a three number versioning system (e.g., 1.0.0)
- Harpy also supports two-number versioning (e.g., 1.0)
- Harpy also supports four-number versioning (e.g., 1.0.0.0)
- Harpy only works with numbers.

## Swift Support
Harpy was ported to Swift by myself and [**Aaron Brager**](http://twitter.com/GetAaron). We've called the new project [**Siren**](https://github.com/ArtSabintsev/Siren).

## Features
- [x] CocoaPods Support
- [x] Carthage Support
- [x] Localized for 40+ languages (See **Localization**)
- [x] Pre-Update Device Compatibility Check (See **Device Compatibility**)
- [x] Three types of alerts (see **Screenshots & Alert Types**)
- [x] Optional delegate methods (see **Optional Delegate** section)
- [x] Unit Tests!

## Screenshots

- The **left picture** forces the user to update the app.
- The **center picture** gives the user the option to update the app.
- The **right picture** gives the user the option to skip the current update.
- These options are controlled by the `HarpyAlertType` enum that is found in `Harpy.h`.

<img src="https://github.com/ArtSabintsev/Harpy/blob/master/Assets/picForcedUpdate.png?raw=true" height="480"> <img src="https://github.com/ArtSabintsev/Harpy/blob/master/Assets/picOptionalUpdate.png?raw=true" height="480"> <img src="https://github.com/ArtSabintsev/Harpy/blob/master/Assets/picSkippedUpdate.png?raw=true" height="480">

## Installation Instructions

### CocoaPods
``` ruby
pod 'Harpy'
```

### Carthage
``` swift
github "ArtSabintsev/Harpy"
```

### Manual

Copy the 'Harpy' folder into your Xcode project. It contains the Harpy.h and Harpy.m files.

## Setup
1. Import **Harpy.h** into your AppDelegate or Pre-Compiler Header (.pch)
1. In your `AppDelegate`, optionally set the **alertType**.
1. In your `AppDelegate`, call **only one** of the `checkVersion` methods, as all three perform a check on your application's first launch. Use either:
    - `checkVersion` in `application:didFinishLaunchingWithOptions:`
    - `checkVersionDaily` in `applicationDidBecomeActive:`.
    - `checkVersionWeekly` in `applicationDidBecomeActive:`.


``` obj-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	// Present Window before calling Harpy
	[self.window makeKeyAndVisible];

	// Set the UIViewController that will present an instance of UIAlertController
	[[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];

    // (Optional) Set the Delegate to track what a user clicked on, or to use a custom UI to present your message.
        [[Harpy sharedInstance] setDelegate:self];

    // (Optional) When this is set, the alert will only show up if the current version has already been released for X days.
    // By default, this value is set to 1 (day) to avoid an issue where Apple updates the JSON faster than the app binary propogates to the App Store.
        [[Harpy sharedInstance] setShowAlertAfterCurrentVersionHasBeenReleasedForDays:3];

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

	/* (Optional) Overrides system language to predefined language.
	 Please use the HarpyLanguage constants defined in Harpy.h. */
	[[Harpy sharedInstance] setForceLanguageLocalization:<#HarpyLanguageConstant#>];

        /* (Optional): Delays the update prompt by a specific number of days. By default,
	this value is set to 1 day to avoid an issue where Apple updates the JSON faster than the app binary propogates to the App Store.*/
        [[Harpy sharedInstance] setShowAlertAfterCurrentVersionHasBeenReleasedForDays:<#Int#>];

	// Perform check for new version of your app
	[[Harpy sharedInstance] checkVersion];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

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

- (void)applicationWillEnterForeground:(UIApplication *)application {
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

## Differentiated Alerts for Patch, Minor, and Major Updates
If you would like to set a different type of alert for revision, patch, minor, and/or major updates, simply add one or all of the following *optional* lines to your setup *before* calling any of the `checkVersion` methods:

``` obj-c
	/* By default, Harpy is configured to use HarpyAlertTypeOption for all version updates */
	[[Harpy sharedInstance] setPatchUpdateAlertType:<#alert_type#>];
	[[Harpy sharedInstance] setMinorUpdateAlertType:<#alert_type#>];
	[[Harpy sharedInstance] setMajorUpdateAlertType:<#alert_type#>];
	[[Harpy sharedInstance] setRevisionUpdateAlertType:<#alert_type#>];
```

## Optional Delegate and Delegate Methods
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

## Localization
Harpy is localized for
- Arabic
- Armenian
- Basque
- Chinese (Simplified and Traditional)
- Croatian
- Czech
- Danish
- Dutch
- English
- Estonian
- Finnish
- French
- German
- Greek
- Hebrew
- Hungarian
- Indonesian
- Italian
- Japanese
- Korean
- Latvian
- Lithuanian
- Malay
- Norwegian (Bokmål)
- Persian (Iran, Afghanistan, Persian)
- Polish
- Portuguese (Brazil and Portugal)
- Russian
- Serbian (Cyrillic and Latin)
- Slovenian
- Spanish
- Swedish
- Thai
- Turkish
- Ukrainian
- Urdu
- Vietnamese

You may want the update dialog to *always* appear in a certain language, ignoring iOS's language setting (e.g. apps released in a specific country).

You can enable it like this:

``` obj-c
[[Harpy sharedInstance] setForceLanguageLocalization<#HarpyLanguageConstant#>];
```

## Device Compatibility
If an app update is available, Harpy checks to make sure that the version of iOS on the user's device is compatible the one that is required by the app update. For example, if a user has iOS 9 installed on their device, but the app update requires iOS 10, an alert will not be shown. This takes care of the *false positive* case regarding app updating.

## Testing Harpy
Temporarily change the version string in Xcode (within the `.xcodeproj`) to an older version than the one that's currently available in the App Store. Afterwards, build and run your app, and you should see the alert.

If you currently don't have an app in the store, change your bundleID to one that is already in the store. In the sample app packaged with this library, we use the [iTunes Connect Mobile](https://itunes.apple.com/us/app/itunes-connect/id376771144?mt=8) app's bundleID: `com.apple.itunesconnect.mobile`.

## Important Note on App Store Submissions
The App Store reviewer will **not** see the alert.

## Phased Releases
In 2017, Apple announced the [ability to rollout app updates gradually (a.k.a. Phased Releases)](https://itunespartner.apple.com/en/apps/faq/Managing%20Your%20Apps_Submission%20Process). Harpy will continue to work as it has in the past, presenting an update modal to _all_ users. If you opt-in to a phased rollout for a specific version, you will need to remotely disable Harpy until the rollout is done.

## Created and maintained by
[Arthur Ariel Sabintsev](http://www.sabintsev.com/)
