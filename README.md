# Harpy

## Notify users that a new version of your app is available in the AppStore

### About
**Harpy** is a utility that checks a user's currently installed version of your iOS application against the version that is currently available in the AppStore. If a new version is available, an instance of UIAlertView is presented to the user informing them of the newer version, and giving them the option to update the application.

### Screenshots

- The **left picture** forces the user to update the app.
- The **center picture** gives the user the option to update the app.
- The **right picture** gives the user the skip the current update.
- This option is configurable in **Harpy.h**.
 
![Forced Update](https://github.com/ArtSabintsev/Harpy/blob/master/picForcedUpdate.png?raw=true "Forced Update") 
![Optional Update](https://github.com/ArtSabintsev/Harpy/blob/master/picOptionalUpdate.png?raw=true "Optional Update")
![Skipped Update](https://github.com/ArtSabintsev/Harpy/blob/master/picSkippedUpdate.png?raw=true "Optional Update")

### Installation Instructions:

1. Copy the 'Harpy' folder into your Xcode project.

1. Import **Harpy.h** into your AppDelegate or Pre-Compiler Header (.pch)
		
1. Configure the static variables in **HarpyConstants.h**, and remove the ```#warning``` after customizing said variables. 

	- Note: `kHarpyAlertType` is set to `AlertType_Option` by default. 
	- To force the user to update your app on launch, set `kHarpyAlertType` to `AlertType_Force`
	- To allow the user to forego seeing alerts for current AppStore version, set `kHarpyAlertType` to `AlertType_Skip`
	- To have an alert pop up each time the application launches from a full shutdown (e.g., no background), keep the default setting (`KHarpyAlertType == AlertType_Option`).  

1.  In your **AppDelegate.m**, add **only one** of the following methods:
	- `[Harpy checkVersion]` after makeKeyAndVisible is called on your UIWindow iVar in `application:didFinishLaunchingWithOptions:`
	- `[Harpy checkVersionDaily]` in `applicationDidBecomeActive:`
	- `[Harpy checkVersionWeekly]` in `applicationDidBecomeActive:`
	- **NOTE: Call only one of the Harpy methods, as they all perform a check on your application's first launch. Using multiple methods will result in multiple UIAlertViews to pop.**
	
<pre>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	// Present Window before calling Harpy
	[self.window makeKeyAndVisible]
	
	// Perform check for new version of your app 
	[Harpy checkVersion] 
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

	/*
	 Perform daily check for new version of your app
	 Useful if user returns to you app from background after extended period of time
 	 Place in applicationDidBecomeActive:
 	 
 	 Also, performs version check on first launch.
 	*/
	[Harpy checkVersionDaily];

	/*
	 Perform weekly check for new version of your app
	 Useful if user returns to you app from background after extended period of time
	 Place in applicationDidBecomeActive:
	 
	 Also, performs version check on first launch.
	 */
	[Harpy checkVersionWeekly];
    
}
</pre>

And you're all set!

### Important Note on AppStore Submissions
- The AppStore reviewer will **not** see the alert. 

###  Release Notes (v2.2.0):
- Added third option that allows users to skip seeing alerts for current AppStore version

### Contributors
- [Aaron Brager](http://www.github.com/getaaron) in v1.5.0
- [Claas Lange](https://github.com/claaslange) in v2.0.0
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