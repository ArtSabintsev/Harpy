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

1. Import **Harpy.h** into your AppDelegate or Pre-Compiler Header (.pch) file
		
1. Configure the **4** static variables in **Harpy.h*
  
	- ***appID***
	- ***kCurrentLocale***
	- ***kDaysToWaitBeforeAlertingUser***
	- ***forceUpdate***
	- You can remove the ***#warning*** in **Harpy.h** after customizing those variables. 


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
A lot of users, including myself, use the **[Semantic Versioning](http://www.semver.org)** system. This makes it hard for Harpy to compare versions as floats. Therefore, versions are compared as strings. 

Another problem arises with the the JSON results that Apple returns. It only contains the current publicly available version of your app. For example, if version 1.2.5 is the newest version, only that version will be returned inside the JSON results 

Submitting a new version of your App to the store causes Harpy to pop the UIAlertView to the App reviewier. ***No one wants this, especially the revieiwer.***

#### The Solution (Updated in v1.5.0)

- Set the value of **kDaysToWaitBeforeAlertingUser** in **Harpy.h** to a value greater than the number of days that you think your app will be in review. A few days after the date stated at [ShinyDevelopment's ReviewTimes site](http://reviewtimes.shinydevelopment.com) is usually a safe bet. 
- By default, this value is set to **14** in the application.
- Setting this value to 0 pops the the alertView on each launch of your application

###  Release Notes (v1.5.0):
- Smarter submission system for bypassing Apple's reviewers during the review process 
	- Thanks to [Aaron Brager](http://www.github.com/getaaron)

###  Previous Release Notes:
#### v1.0.1
- Added a bugfix for unreleased apps 
	- Thanks to [Pius Uzamere](https://github.com/pius)

#### v1.0.0:
- Initial Release

### Contributors

- [Aaron Brager](http://www.github.com/getaaron) (in v1.5)
- [Pius Uzamere](https://github.com/pius) (in v1.0.1)

### Recognition:

Created by [Arthur Ariel Sabintsev](http://www.sabintsev.com)  
