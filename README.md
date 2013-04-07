# Harpy

## Notify users that a new version of your app is available in the AppStore

### About
**Harpy** is a utility that checks a user's currently installed version of your iOS application against the version that is currently available in the AppStore. If a new version is available, an instance of UIAlertView is presented to the user informing them of the newer version, and giving them the option to update the application.

### Features
- Three types of alerts to present to the end-user (see **Screenshots** section)
- Localized for 11 languages
	- Chinese (Simplified)
	- Chinese (Traditional)
	- Danish
	- Dutch
	- English
	- French
	- German
	- Italian
	- Japanese
	- Russian
	- Spanish
- Optional delegate and delegate methods (see **Optional Delegate** section)

### Screenshots

- The **left picture** forces the user to update the app.
- The **center picture** gives the user the option to update the app.
- The **right picture** gives the user the skip the current update.
- This option is based on the `HarpyAlertType` struct that is found in `Harpy.h`.
 
![Forced Update](https://github.com/ArtSabintsev/Harpy/blob/master/picForcedUpdate.png?raw=true "Forced Update") 
![Optional Update](https://github.com/ArtSabintsev/Harpy/blob/master/picOptionalUpdate.png?raw=true "Optional Update")
![Skipped Update](https://github.com/ArtSabintsev/Harpy/blob/master/picSkippedUpdate.png?raw=true "Optional Update")

### Installation Instructions:
**Note: Harpy utilizes ARC. Add the *-fobjc-arc* compiler flag in the build phases tab if your project doesn't use ARC**.

1. Copy the 'Harpy' folder into your Xcode project.

1. Import **Harpy.h** into your AppDelegate or Pre-Compiler Header (.pch)

1. In your `AppDelegate`, set the `appID` for your app: `[[Harpy sharedInstance] setAppID:@"<app_id>"]`.

1. In your `AppDelegate`, set the `alertType` for your app: `[[Harpy sharedInstance] setAlertType:<alert_type>]`.

1.  In your `AppDelegate`, add **only one** of the `[[Harpy sharedInstance] checkVersion]` methods.	
	- **NOTE: Call only one of the Harpy methods, as they all perform a check on your application's first launch. Using multiple methods will result in multiple UIAlertViews to pop.**
	
``` obj-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	// Present Window before calling Harpy
	[self.window makeKeyAndVisible]
	
	// Set the App ID for your app
	[[Harpy sharedInstance] setAppID:@"<app_id>"];
	
	/* (Optional) Set the Alert Type for your app 
	 By default, the Singleton is initialized to HarpyAlertTypeOption */
	[[Harpy sharedInstance] setAlertType:<alert_type>];
	
	// Perform check for new version of your app 
	[[Harpy sharedInstance] checkVersion] 
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
	 Useful if user returns to you app from background after extended period of time
	 Place in applicationDidBecomeActive:
	 
	 Also, performs version check on first launch.
	 */
	[[Harpy sharedInstance] checkVersionWeekly];
    
}
```

And you're all set!

### Optinonal Delegate and Delegate Method
If you'd like to handle or track the end-user's behavior, four delegate methods have been made available to you:

```	

	// User presented with update dialog
	- (void)harpyDidShowUpdateDialog;
	
	// User did click on button that launched App Store.app
	- (void)harpyUserDidLaunchAppStore;
	
	// User did click on button that skips version update
	- (void)harpyUserDidSkipVersion;
	
	// User did click on button that cancels update dialog
	- (void)harpyUserDidCancel;

```

### Important Note on AppStore Submissions
- The AppStore reviewer will **not** see the alert. 

###  Release Notes (v2.3.0):
- Huge thanks to [David Keegan](https://github.com/kgn) for doing the bulk of the heavy lifting on this version.
- Internationalization and Localization for 10 languages
	- Chinese (Simplified)
	- Chinese (Traditional)
	- Danish
	- Dutch
	- French
	- German
	- Italian
	- Japanese
	- Russian
	- Spanish
- Harpy is now a Singleton
- Optional delegate and delegate methods added

### Contributors
- [Aaron Brager](http://www.github.com/getaaron) in v1.5.0
- [Claas Lange](https://github.com/claaslange) in v2.0.0
- [David Keegan](https://github.com/kgn) in v2.3.0
- [Josh T. Brown](https://github.com/joshuatbrown) in v2.0.0
- [Pius Uzamere](https://github.com/pius) in v1.0.1

### Recognition:

Created by [Arthur Ariel Sabintsev](http://www.sabintsev.com)  

### License
The MIT License (MIT)
Copyright (c) 2012 Arthur Ariel Sabintsev

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
