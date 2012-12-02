# Harpy

## Notify users that a new version of your app is available in the AppStore

### About
**Harpy** is a utility that checks a user's currently installed version of your iOS application against the version that is currently available in the AppStore. If a new version is available, an instance of UIAlertView is presented to the user informing them of the newer version, and giving them the option to update the application.

### Pictures

- The **left picture** forces the user to update the app.
- The **right picture** gives the user the option to update the app.
- You can configure this option in **Harpy.h**.
 
![Forced Update](https://github.com/ArtSabintsev/Harpy/blob/master/picForcedUpdate.png?raw=true "Forced Update") 
![Optional Update](https://github.com/ArtSabintsev/Harpy/blob/master/picOptionalUpdate.png?raw=true "Optional Update")

### Installation Instructions:

1. Copy the 'Harpy' folder into your Xcode project. The following files will be added:
	1. Harpy.h
	1. Harpy.m
1. Configure the static variables in **Harpy.h**
	- ***appID***: NSString that holds your Application's AppID (this can be found in iTunes Connect)
	- ***forceUpdate***: BOOL that decides if a user has the option to update the application at a later point
		- If ***forceUpdate*** is set to ***YES***, a user will be presented with a UIAlertView that has 1 button
			1. Update button = Launches the AppStore app
		- If ***forceUpdate*** is set to ***NO***, a user will be presented with a UIAlertView with 2 buttons
			1. Cancel button = Dismisses the UIAlertView
			1. Update buton = Launches the AppStore app 
	- You can remove the ***#warning*** after filling these two in  
1. Import **Harpy.h** into your AppDelegate or Pre-Compiler Header (.pch) file
1. In your **AppDelegate.m**, add ***[Harpy checkVersion]*** after calling ***makeKeyAndVisible***:

<pre>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Customization on application launch
	
	…
	
	// Present Window
	[self.window makeKeyAndVisible]
	
	/*  
		Check AppStore for your application's current version. If newer version exists, prompt user.
		Declare immediatley after you call makeKeyAndVisible on your UIWindow iVar
	*/
	[Harpy checkVersion] 
}

</pre>

And you're all set!

### Important Note on AppStore Submissions
#### The Problem
A lot of users, including myself, use the **[Semantic Versioning](http://www.semver.org)** system. 

- This makes it hard for Harpy to compare versions as floats. Therefore, versions are compared as strings. 

Another problem arises with the the JSON results that Apple returns

- Apple only contains the current publicly available version of your app 
- E.g., if version 1.2.5 is the newest version, only that version will be returned inside the JSON results 

Submitting a new version of your App to the store causes Harpy to pop the UIAlertView to the App reviewier. 

#### The Solution

When submitting an update to your app to the App Store, make sure to put the **[Harpy checkVersion]** code inside an NSDate conditional, and set the NSDate for sometime in the future (usually 2 weeks after you submit your app). This will allow you to get this code to your end-users without annoying the Apple reviewer.

###  Release Notes (v1.0.1):
- Added a bugfix for unreleased apps (Thanks to [Pius Uzamere](https://github.com/pius))
- Augmented ReadMe section: *Important Note on AppStore Submissions*

###  Previous Release Notes
#### v1.0.0:
- Initial Release

### Recognition:

Created by [Arthur Ariel Sabintsev](http://www.sabintsev.com)  
