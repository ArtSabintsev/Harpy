# Harpy

## Notify users that a new version of your app is available in the AppStore

### About
**Harpy** is a utility that checks a user's currently installed version of your iOS application against the version that is currently available in the AppStore. If a new version is available, an instance of UIAlertView is presented to the user informing them of the newer version, and giving them the option to update the application.

### Screenshots

- The **left picture** forces the user to update the app.
- The **right picture** gives the user the option to update the app.
- This option is configurable in **Harpy.h**.
 
![Forced Update](https://github.com/ArtSabintsev/Harpy/blob/master/picForcedUpdate.png?raw=true "Forced Update") 
![Optional Update](https://github.com/ArtSabintsev/Harpy/blob/master/picOptionalUpdate.png?raw=true "Optional Update")

### Installation Instructions:

1. Copy the 'Harpy' folder into your Xcode project. The following files will be added:
	1. Harpy.h
	1. Harpy.m

1. Import **Harpy.h** into your AppDelegate or Pre-Compiler Header (.pch)
		
1. Configure the **5** static variables in **HarpyConstants.h**
	- You can remove the ***#warning*** in **Harpy.h** after customizing those variables. 
1.  In your **AppDelegate.m**, add ***[Harpy checkVersion]*** after calling ***makeKeyAndVisible***:

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
- As of 2.0.0, no extra configuraiton needs be performed to avoid having the AppStore reviewer see the alert. 

###  Release Notes (v2.0.1):
- Moved customizable strings to new file, ***HarpyConstants.h***

### Contributors
- [Aaron Brager](http://www.github.com/getaaron) in v1.5.0
- [Claas Lange](https://github.com/claaslange) in v2.0.0
- [Josh T. Brown](https://github.com/joshuatbrown) in v2.0.0
- [Pius Uzamere](https://github.com/pius) in v1.0.1

### Recognition:

Created by [Arthur Ariel Sabintsev](http://www.sabintsev.com)  
