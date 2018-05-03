======
Before posting an issue, please make sure your issue has not already been resolved or answered elsewhere.

Common Issue #1:
> "How do I use Harpy if my app is not available in the US App Store?""

Add the corresponding country code when setting up Harpy.

Common Issue #2:
> "Support for macOS App Store."

Harpy does not and will not support the macOS App Store.

Common Issue #3:
> "Support for prompting TestFlight users to update to the newest beta build."

Harpy does not support this functionality. There is no publicly accessible TestFlight API akin to that of the public App Store API that harpy can utilize to provide this functionality.

Please delete this text before submitting a new issue.

Common Issue #4:
> "Infinite Loop Updates"

On rare occasion, Apple may update their App Store JSON _faster_ than the binary appears in the App Store. Due to this issue, developers who make use of the `.force` option may be prompting their users with app updates whenever launching the app, effectively creating an infinite loop until the binary appears. To fix this issue, set the `setShowAlertAfterCurrentVersionHasBeenReleasedForDays` variable to a value greater than 0. By default, it's set to 1 to avoid this issue, as the alert does not show until 24-hours/1-day has passed

======
