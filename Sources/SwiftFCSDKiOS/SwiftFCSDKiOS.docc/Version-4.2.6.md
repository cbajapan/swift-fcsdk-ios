# Version 4.2.6

This article describes changes in version 4.2.6 of FCSDKiOS

## Overview

Version 4.2.6 has several bug fixes and performance improvements. Below is a list of bug fixes.

### Improvements to ACBUCDelegate methods

### Improvements to localBufferView

### Improvements to network connectivity

### Improvements to Virtual Background

### Transport performance improvements

### Video View performance improvements

### Concurrency improvements

### Improvements to logging and setting call state

### iOS13 TrustAll Certificates (insecure connections)

### iOS12 loading crash addressed

### Video Direction Bug

### Uses Version m117 of WebRTC

### Fixed a bug where the remoteView video stream may not have resumed streaming from an on hold state.

### Addresses H264 Codecs

**Important Note**
_If you find yourself in a situation where **ACBClientCallDelegate** is not being set in time, please ensure that you are calling it as soon as the call is available during your call flow. In some scenarios, you may need to set it asynchronously via the *setDelegate(callDelegate:)* method in order to make sure it is set properly in the SDK, but please use this method as a last resort._

