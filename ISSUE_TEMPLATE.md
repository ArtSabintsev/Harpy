======
Before posting an issue, please make sure your issue has not already been resolved or answered elsehwere.

Common Issue #1:
> "Error retrieving iOS version number as there was no data returned."

Check if your app is available in the US App Store, otherwise add the corresponding country code when setting up Siren: https://github.com/ArtSabintsev/Siren/blob/master/Siren/Siren.swift#L198

Common Issue #2:
> "Support for macOS App Store."

Siren does not and will not support the macOS App Store.

Common Issue #3:
> "Support for prompting TestFlight users to update to the newest beta build."

Siren does not support this functionality. There is no publicly accessible TestFlight API akin to that of the public App Store API that Siren can utilize to provide this functionality.

Please delete this text before submitting a new issue.

Common Issue #4:
> "Infinite Looping of App Store Prompt"

If you use the `.force` update option and your app prompts the user to download the latest version from the App Store, and the latest verison happens to be unavailable, an infinite loop will occur. This is undesirable UX. To address this issue, simple set `setShowAlertAfterCurrentVersionHasBeenReleasedForDays` to a value of 1-3 days. By default, this value is set to `1` day to avoid this exact issue.
======
