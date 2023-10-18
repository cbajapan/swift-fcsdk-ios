# ACBVideoDevice

Contains a method used to return an array of capture settings.

## Overview

```swift
    /// We Define our device based off of the appropriate capture settings
    final public class ACBDevice {

     /// FCSDK's ``ACBDevice`` Object's ``recommendedCaptureSettings()``
     /// - Returns: An array of ``ACBVideoCaptureSetting``
     @available(*, deprecated, message: "Please use async version, Future versions of FCSDKiOS will remove this method.")
     @objc final public func recommendedCaptureSettings() -> [FCSDKiOS.ACBVideoCaptureSetting]
    
     /// FCSDK's ``ACBDevice`` Object's ``recommendedCaptureSettings()``
     /// - Returns: An array of ``ACBVideoCaptureSetting``
     @objc public func recommendedCaptureSettings() async -> [ACBVideoCaptureSetting]? {
}
```
