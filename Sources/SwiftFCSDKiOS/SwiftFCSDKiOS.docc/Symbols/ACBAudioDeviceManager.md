# ACBAudioDeviceManager

ACBAudioDeviceManager allows us to set both default and preferred audio device capabilities. Please see <doc:ACBAudioDevice> for device capabilities.
## Overview

```swift
/// `ACBAudioDeviceManager` is intended for applications to be able to interact with the AVSession in FCSDK
@objc final public class ACBAudioDeviceManager : NSObject, @unchecked Sendable {

    @objc final public func start()

    /// Stops the `AVAudioSession`
    @objc final public func stop()

    /// Available Audio Input Routes
    /// - Returns: Any array of Available inputs
    @objc final public func audioDevices() -> [AnyHashable]?

    /// The Selected Audio Devices perferred Input
    /// - Returns: Returns the selected device with the perferred input
    final public func selectedAudioDevice() -> FCSDKiOS.ACBAudioDevice

    /// Sets the default audio device from the ``ACBAudioDevice``
    /// - Parameter device: Takes a parameter of `AVAudioSession`
    @objc final public func setDefaultAudio(_ device: FCSDKiOS.ACBAudioDevice)

    /// Sets the audio device from the ``ACBAudioDevice``
    /// - Parameter device: Takes a parameter of `AVAudioSession`
    @objc final public func setAudioDevice(_ device: FCSDKiOS.ACBAudioDevice)

    /// This method is intended to referesh the speakerPhone setting if it is needed
    @objc final public func refreshSpeakerphoneSetting()

    /// This method tells WebRTC that we want to use manual Audio
    @objc final public class func useManualAudioForCallKit()

    ///  This method activates the **CallKit**  Audio Session and passes it up to **WebRTC**. This method must be called on
    ///  **func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession)**
    /// - Parameter audioSession: Our Audio Session from the **CallKit** provider delegate
    @objc final public class func activeCallKitAudioSession(_ audioSession: AVAudioSession)

    ///  This method deactivates the **CallKit** Audio Session and passes it up to **WebRTC**. This method must be called on
    ///  **provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession)**
    /// - Parameter audioSession: Our Audio Session from the **CallKit** provider delegate
    @objc final public class func deactiveCallKitAudioSession(_ audioSession: AVAudioSession)
}
```

## Bluetooth Support

The user can set the active audio device (speaker and microphone) for an iOS device, and FCSDK calls will use this setting by default. However, this behavior may not be appropriate while an FCSDK application is running; and in particular, the default behavior does not allow the call to switch to an alternative device if the active device fails (a particular problem with Bluetooth devices). The application can override the default behavior using the ACBAudioDeviceManager class; a single instance of this class is available on the ACBClientPhone object which controls the call. While this is in use, the application can:

-  Define which audio output on the phone should handle the audio

-  Define a default audio output on the phone, which will handle the audio if the preferred device is interrupted.

-  Get a list of available audio outputs on the phone

-  Determine which of the phone's audio outputs currently handles the audio

This class has been added specifically to support the use of Bluetooth headsets, and we expect this to be its main use; accordingly, the examples assume that this is how it is being used. However, an application could also use this class to manage the audio output to the speakerphone, the internal speaker, and an external headphone set, and to explicitly _exclude_ the use of Bluetooth headsets with the calls made by the application.

### Starting and Stopping ACBAudioDeviceManager

In order to use the methods on the ACBAudioDeviceManager, the application must first call the start method of the instance in the ACBClientPhone which is handling the call:
```swift
    uc.phone.audioDeviceManager.start()
```
An appropriate place to do this is during initialization of the object which is to control the call.

After the ACBAudioDeviceManager starts, the application can call its methods to set the audio devices which the phone should use for calls made or received by the application. Calls which are not handled by the FCSDK application will be unaffected, and will use the phone's default behavior.

In order to return to the iOS device's default behavior without ending the call, the application can call stop:
```swift
    uc.phone.audioDeviceManager.stop()
```
While the audio device manager is active the application **_must not_** call the setCategory method of the call's AVAudioSession object. Doing so can cause unexpected behavior.

### Setting the Preferred Device

The application can set the preferred device for the call:
```swift
    uc.phone.audioDeviceManager.setAudioDevice(.earpiece)
```
**The argument to the method must be one of the members of the <doc:ACBAudioDevice> enumeration:**
```swift

/// Audio goes to the loudspeaker in the phone, and is audible to others in the vicinity. Audio input is from the phone's internal microphone.
  .speakerphone

/// Audio goes to a device attached to the jack in the phone. If this device has a microphone, that is used for audio input.
  .wiredHeadset

/// Audio goes to the internal speaker, and is received from the internal microphone. The user will have to hold the phone to their ear during the call.
  .earpiece

/// Audio is sent to and received from a paired Bluetooth device.
  .bluetooth

/// The application has no preference, and accepts the default behavior of the iOS device.
  .none
```

If the preferred device is available when the application calls setAudioDevice, the call starts using that device; otherwise, there is no immediate change, but if it later becomes available (the Bluetooth device is switched on or is otherwise recognized), then the audio switches to this device.

### Setting the Default Device

The application can set a fallback device in case the preferred device is unavailable:
```swift
    uc.phone.audioDeviceManager.setDefaultDevice( .earpiece)
```
The argument is one of the values from the ACBAudioDevice enumeration <doc:ACBAudioDevice>

Setting the default device establishes a fallback option in case the preferred device is temporarily unavailable. A common use would be:
```swift
    uc.phone.audioDeviceManager.setAudioDevice( .bluetooth)
    uc.phone.audioDeviceManager.setAudioDevice( .earpiece)
```
which would establish the Bluetooth headset as the preferred device, with the normal phone internal speaker and microphone as a fallback. With these settings in operation:

1.   The call starts, but no Bluetooth headset is available. The call is sent to the internal speaker and microphone.

2.   The Bluetooth headset is switched on. The phone switches the audio to the headset, and the user can put the phone down and continue the call.

3.   The headset fails (perhaps the battery becomes too low). The application switches the call back to the internal speaker and microphone.

4.   The user switches on another (fully powered) Bluetooth headset and pairs it with the phone. The audio switches to the new headset and the call continues on that device.

If the default device is also unavailable, the audio will be sent to whatever has been set as the active device on the phone (that is, it will fallback to the iOS default behavior).

### Listing Available Devices

The application can get a list of available audio devices by calling the audioDevices method:
```swift
    let devices = uc.phone.audioDeviceManager.audioDevices()
```
The resulting array contains members of the ACBAudioDevice enumeration, taken from the available inputs known to the AVAudioSession.

It can also find which device is currently set as the preferred audio device:
```swift
    let selectedDevice = uc.phone.audioDeviceManager.selectedAudioDevice()
```
This will work whether the preferred device has been set explicitly (using setAudioDevice) or not.

