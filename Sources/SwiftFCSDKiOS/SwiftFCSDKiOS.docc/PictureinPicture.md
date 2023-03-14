# Picture in Picture

FCSDKiOS offers Picture in Picture support. In order to use this feature you will need to be able to conform to **AVPictureInPictureControllerDelegate** and/or **AVPictureInPictureSampleBufferPlaybackDelegate**. The **SDK** consumer is completely responsible for conforming to these delegates. However you will need to get a layer or view from the **SDK** to present in the **AVPictureInPicture** code.

## Overview

The Picture in Picture feature is set up in the consumer of the **SDK**, however **FCSDKiOS** gives you all of the needed pieces in order to build a PiP app. 2 things are required to use Picture in Picture mode:

1. Your application must be using **FCSDKiOS**'s Preview Buffer View
2. Your application must be using **FCSDKiOS**'s Sample Buffer View

If you have conformed to these 2 **UIView**s please see how to set up Picture in Picture below.

### AVCaptureSession
In order to check if your devices support Multitasking Camera Access, when a **PreviewBufferView** is created we can get the **AVCaptureSession** from the **PreviewBufferView**. If your Devices is supported by Apple, you can use the new **AVPictureInPictureVideoCallViewController** provided by Apple. Otherwise, you will need to continue using **AVPictureInPictureController** and request permission from Apple for the proper entitlement. This method only works if you are using **PreviewBufferView** for your Local Video UIView.
```swift
@available(iOS 15, *)
@objc final public func captureSession() async -> AVCaptureSession?
```

An example in checking for the method is as follows:
```swift
    if captureSession.isMultitaskingCameraAccessSupported {
        // Use AVPictureInPictureVideoCallViewController
    } else {
        // Use AVPictureInPictureController
    }
```

### Set PiP Controller
Each **ACBClientCall** object has a `setPipController` method that is required for Picture in Picture. This method informs the **SDK** who the **AVPictureInPictureController** is and allows us to receive its delegate methods. This is required for us to handle the **SampleBufferView** accordingly when tha app activates Picture in Picture.
```swift
@available(iOS 15, *)
@MainActor @objc final public func setPipController(_ controller: AVPictureInPictureController) async
```

Now that you have an understanding of the requirements, please see the example below of how a PiP flow could be written.

```swift
@available(iOS 15.0, *)
var pipController: AVPictureInPictureController!


func showPip(show: Bool) async {
if show {
    if AVPictureInPictureController.isPictureInPictureSupported() {
        pipController.startPictureInPicture()
        } else {
        self.logger.info("PIP not Supported")
        }
    } else {
        pipController.stopPictureInPicture()
    }
}

func setUpPip() async {
guard let sampleBufferView = sampleBufferView else { return }

if #available(iOS 16.0, *) {
        guard let captureSession = captureSession else { return }
        if captureSession.isMultitaskingCameraAccessSupported {
            let pipVideoCallViewController = AVPictureInPictureVideoCallViewController()
            pipVideoCallViewController.preferredContentSize = CGSize(width: 1080, height: 1920)
            pipVideoCallViewController.view.addSubview(sampleBufferView)

            let source = AVPictureInPictureController.ContentSource(
            activeVideoCallSourceView: sampleBufferView,
            contentViewController: pipVideoCallViewController)

            pipController = AVPictureInPictureController(contentSource: source)
            pipController.canStartPictureInPictureAutomaticallyFromInline = true
            pipController.delegate = self
            await self.fcsdkCallService.fcsdkCall?.call?.setPipController(pipController)
        } else {
            //If we are iOS 16 and we are not an m chip
           await aChipLogic()
        }
    } else {
       await aChipLogic()
    }
}

func aChipLogic() async {
    let layer = sampleBufferView.layer as? AVSampleBufferDisplayLayer
    guard let sourceLayer = layer else { return }

    let source = AVPictureInPictureController.ContentSource(sampleBufferDisplayLayer: sourceLayer, playbackDelegate: self)

    pipController = AVPictureInPictureController(contentSource: source)
    pipController.canStartPictureInPictureAutomaticallyFromInline = true
    pipController.delegate = self
    await self.fcsdkCallService.fcsdkCall?.call?.setPipController(pipController)
}

```

## Available FCSDK Objects
<doc:ACBUCObject>

<doc:ACBUCDelegate>

<doc:ACBUCOptions>

<doc:ACBAudioDevice>

<doc:ACBAudioDeviceManager>

<doc:ACBClientAED>

<doc:ACBClientCall>

<doc:ACBClientCallDelegate>

<doc:ACBClientCallErrorCode>

<doc:ACBClientCallProvisionalResponse>

<doc:ACBClientCallStatus>

<doc:ACBClientPhone>

<doc:ACBMediaDirection>

<doc:ACBTopic>

<doc:ACBVideoCapture>

<doc:AedData>

<doc:TopicData>

<doc:Constants>

