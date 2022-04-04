# ACBVideoDevice

Contains a method used to return an array of capture settings.

## Overview

```swift
/// We Define our device based off of the appropriate capture settings
final public class ACBDevice {

    /// FCSDK's ``ACBDevice`` Object's ``recommendedCaptureSettings()``
    /// - Returns: An array of ``ACBVideoCaptureSetting``
    @objc final public func recommendedCaptureSettings() -> [FCSDKiOS.ACBVideoCaptureSetting]
}
```
