# FCSDKUI

In this article we will discuss how FCSDK works in the User Interface.

## Overview
FCSDK is an iOS framework that leverages Real Time Communication Technology. We have API's that incorporate UIKit as a first class citizen. However in order to use such a rich API with SwiftUI a relatively new UI framework, we must Use Apple's recommended way of leveraging UIKit inside of SwiftUI views call UIViewControllerRepresentable. This Article will introduce how we can use FCSDK both in UIKit and SwiftUI.

## UIKit

UIKit has been around for years and is truly a rich UI framework to use in building iOS applications. When it comes to iOS applications UIKit can do just about whatever you can think of on an iOS phone with in Apple's guidelines. Which is why it is easy to use FCSDK inside of UIKit. A typical set up in UIKit would look something like this.

```swift
class CommunicationViewController: UIViewController {

override func viewDidLoad() {
    super.viewDidLoad()

}

}
```
Here we have a bare bones view controller class. Let's import FCSDK and add some properties and methods
```swift

import UIKit
import FCSDKiOS


class CommunicationViewController: UIViewController {

var remoteView = UIView()
var previewView = UIView()
var fcsdkCall: FCSDKCall?


override func viewDidLoad() {
    super.viewDidLoad()
        await setupUI()
        await anchors()
}

@MainActor
func setupUI() async {
    self.view.addSubview(self.remoteView)
    self.remoteView.addSubview(self.previewView)
}

@MainActor
func anchors() async {
    self.remoteView.anchors(
        top: self.view.topAnchor,
        leading: self.view.leadingAnchor,
        bottom: self.view.bottomAnchor,
        trailing: self.view.trailingAnchor,
        topPadding: 0,
        leadPadding: 0,
        bottomPadding: 0,
        trailPadding: 0,
        width: 0,
        height: 0)

    self.previewView.anchors(
        top: nil,
        leading: nil,
        bottom: self.view.bottomAnchor,
        trailing: self.view.trailingAnchor,
        topPadding: 0,
        leadPadding: 0,
        bottomPadding: 110,
        trailPadding: 20,
        width: 150,
        height: 200)
    }

func feedRemoteViewToFCSDK() {
    //We can feed the view once `uc.phone.createCall()` object has been created
    self.fcsdkCall?.call?.remoteView = self.fcsdkCall?.remoteView
}

func feedPreveiwViewToFCSDK() {
    //We can feed the view once the UC Object has been initailized
    uc.phone.previewView = previewView
}
}
```
So we just wrote alot of code. But it is fairly straight forward and simple. Here is a list of steps we just implemented.
1. We imported the frameworks
2. We created properties that we need. 
3. We wrote a *setupUI()* method and added the *remoteView* to the view and then we added the *previewView* to the *remoteView*.
4. We anchored our views to the appropriate locations with our *anchors()* method.
5. we called both the *setupUI()* and *anchors()* methods to the View to be displayed when the **viewDidLoad**.
6. We wrote 2 method to feed the UI to FCSDK at the appropriate times. 

That is pretty much it when working with FCSDK in UIKit. So now let's talk about SwiftUI...

## SwiftUI

SwiftUI framework adds another level of complexity. The question we are left with is how do we use UIKit in SwiftUI? The Answer? **UIViewControllerRepresentable**.

### UIViewControllerRepresentable

We need to add another class to our project. We can pretty much call it whatever we want, but we need to conform it to certain protocols. 

```swift
import UIKit
import SwiftUI
import FCSDKiOS

struct CommunicationViewControllerRepresentable: UIViewControllerRepresentable {
func makeUIViewController(context: UIViewControllerRepresentableContext<CommunicationViewControllerRepresentable>) -> CommunicationViewController {
    let communicationViewController = CommunicationViewController()
    return communicationViewController
}

func updateUIViewController(_
                            uiViewController: CommunicationViewController,
                            context: UIViewControllerRepresentableContext<CommunicationViewControllerRepresentable>
) {

}
}
```
And that should do for now. Let's talk about what we did. We wrote a class that conforms to **UIViewControllerRepresentable**. That protocol requries us to write 2 methods **makeUIViewController()** and **updateUIViewController**. As the names suggest we make our UIKit View Controller with one and update it with the other. However for us to be able to pass our UIKit views to SwiftUI we need to write another class within the class we just wrote. We will call this class Coordinator.

```swift

struct CommunicationViewControllerRepresentable: UIViewControllerRepresentable {
func makeUIViewController(context: UIViewControllerRepresentableContext<CommunicationViewControllerRepresentable>) -> CommunicationViewController {
    let communicationViewController = CommunicationViewController()
    return communicationViewController
}

func updateUIViewController(_
                            uiViewController: CommunicationViewController,
                            context: UIViewControllerRepresentableContext<CommunicationViewControllerRepresentable>
) {

}

class Coordinator: NSObject {
    
    var parent: CommunicationViewControllerRepresentable
    
    init(_ parent: CommunicationViewControllerRepresentable) {
        self.parent = parent
    }
func makeCoordinator() -> Coordinator {
    Coordinator(self)
}
}

}
```
So what coordinator is going to do for us is let us access the parent class which is **CommunicationViewControllerRepresentable** that parent is going to have our **ACBClientCall** Object on it where our **previewView** Object exists in FCSDK. We also need to write a custom protocol to pass our views from UIKit to its parent. So let's implement that logic.

```swift
@Binding var fcsdkCall: FCSDKCall?

class Coordinator: NSObject, FCSDKCallDelegate {
    
    var parent: CommunicationViewControllerRepresentable
    
    init(_ parent: CommunicationViewControllerRepresentable) {
        self.parent = parent
    }

func passViewsToService(preview: UIView, remoteView: UIView) async {
    await self.parent.fcsdkCall?.previewView = preview
    await self.parent.fcsdkCall?.remoteView = remoteView
}

func makeCoordinator() -> Coordinator {
    Coordinator(self)
}

}

protocol FCSDKCallDelegate: AnyObject {
    func passViewsToService(preview: UIView, remoteView: UIView) async
}
```
Simple enough right? We write the protocol, create the Bindable property on **CommunicationViewControllerRepresentable** and pass the properties up the pipe. But we have a couple more things to do for it to work. Inside CommunicationViewController lets make some changes.
```swift
weak var fcsdkCallDelegate: FCSDKCallDelegate?

func pass viewsAtTheRightTime() {
await self.fcsdkCallDelegate?.passViewsToService(preview: self.previewView, remoteView: self.remoteView)
}
```
So now we will be able to pass our views to **CommunicationViewControllerRepresentable**, but first we need to set the delegate. So let's move back into that class.
```swift
func makeUIViewController(context: UIViewControllerRepresentableContext<CommunicationViewControllerRepresentable>) -> CommunicationViewController {
    let communicationViewController = CommunicationViewController()
    communicationViewController.fcsdkCallDelegate = context.coordinator
    return communicationViewController
}
```
Excellent, with all that said and done, we can call our **CommunicationViewControllerRepresentable** class inside our SwiftUI View.

```swift
struct Communication: View {
@EnvironmentObject var fcsdkCallService: FCSDKCallService
var body: some View {
        ZStack(alignment: .topTrailing) {
            CommunicationViewControllerRepresentable(
                fcsdkCall: self.$fcsdkCallService.fcsdkCall,
                )           
            }
        }
    }
```
So with all that hard work you should be able to get FCSDK working in your SwiftUI applications. Please play around with the UI flow to get the desire UI you wish and reference the sample app in order to see a real world example.
