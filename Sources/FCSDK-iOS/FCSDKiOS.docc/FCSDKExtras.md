# FCSDK Extras

This Article discusses all of the extra important details of FCSDK not covered in other articles

## SPM
To set up a project using the Swift Package we want to depend on the Swift Package at the root level of your project. 

1.   Open your Xcode project, navigate to the project, and then into Package Dependencies. Click the + button and add the pacakge like so.
![An image showing how to add FCSDKiOS](image_4.png)
2.   We want to make sure that the binary has been linked to the project. Click the **General** tab of your Target, and expand the _Frameworks, Libraries, and Embedded Content_ section by clicking on the title.
3.   If the Binary is not embedded then click the **+** button; the file explorer displays.
4.   Select the FCSDK-iOS Library and press add
![An image showing how to add FCSDKiOS](image_5.png)
5.   Done, your project is now ready to use Fusion Client SDK

## Bitcode Support
Bitcode can be enabled in the Build Settings
```
    Enable Bitcode = YES
```
## Simulator Support
We now offer simulator support with FCSDKiOS. It is simple to set up. The Simulator does not support the use of the camera, therefore we need to give it a video to stream to your real device.

1. Create a short placeholder video (about 5 seconds long) and name it `Simulator.mp4`.

2. Drag and Drop the `.mp4` into the root level of your application like the picture shows bellow.

![An image showing how to add FCSDKiOS](image_6.png)

3. Make sure you select `copy items if needed` and select the `target` you wish to add the video to, like the picture shows below.

![An image showing how to add FCSDKiOS](image_7.png)

It is now set up. Now when you make calls with the simulator, you will see the video from your real device and the mp4 will stream from the simulator. 

## Using FCSDK Swift Package in a Framework or Static Library

**If you are interested in building a Static Library instead of a Framework the process is the same**

FCSDKiOS consists of 2 Frameworks
1. FCSDKiOS
3. CBARealTime

The nature of Frameworks and Static Libraries cause us to use them in a very specific way. Apple will not allow Embedded Frameworks to be released on the App Store in iOS. So that means if you try and embed these 2 frameworks into your framework, it will inevitably fail. What you want to do when it comes to depending on a framework within your framework is to link the child framework to the parent framework, but **DO NOT EMBED THEM**. This will result in the External Symbols being linked, but not the internal symbols. So, if you try to place the framework you created in your application, you will get several errors saying that there are symbols missing. How can this be resolved? You need to import those same 2 frameworks you depend on in your framework into the Application you are building. 

This seems like a lot of work, so we have done most of it for you with our Swift Package.

All you need to do is import the Swift Package into your framework as described above. However, what you will need to do in order to use the Framework you are developing in an iOS application has a couple of steps you will need to follow.

We basically have 2 options. 
1. Do as described above and import your framework that depends on FCSDKiOS along with FCSDKiOS into the iOS application. 
OR
2. Let Swift Package Manager handle all of that for you.

**We will describe option 2, as it is our recommendation.**

You will want to create a Swift Package in order to distribute your XCFramework.

1. Open Terminal
2. Create a directory - you can name it something like `my-framework-kit` with `mkdir MY_DIRECTORY`
2. Move into that directory with `cd my-framework-kit`
3. Create the Swift Package with `swift package init`
4. Open `Package.swift` in Xcode
5. Make sure that your XCFramework is in the root directory of the Swift Package, so in our case, it should be located in `my-framework-kit`

**Now, with you Package.swift open make sure it looks like this**
```swift
// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "my-framework-kit",
    products: [
        .library(
            name: "my-framework-kit",
            type: .static,
            targets: ["my-framework-kit"]),
    ],
    dependencies: [
        .package(name: "FCSDKiOS", url: "https://github.com/cbajapan/FCSDKiOS.git", .exact("4.0.0"))
    ],
    targets: [
        .target(
            name: "my-framework-kit",
            dependencies: [
                "my-framework",
                .product(name: "FCSDKiOS", package: "FCSDKiOS")
            ]),
        .binaryTarget(name: "my-framework", path: "my-framework.xcframework")
    ]
)
```
I will describe what this file does - What we are mostly interested in is the **Package**

Inside this initializer, we have 4 properties
1. Name
2. Products
3. Dependencies
4. Target

* Name is not super important to us, but typically this is the name of the directory you made
* Products consists of the Libraries name; we also need to specify this Library as a Static Library, and we want to tell it about our Target that we define in **Packages** final property.
* Dependencies are any code that you want to bring in from a url that is an internal or external resource, so basically, other Swift Packages. Here we are depending on `FCSDKiOS`
* Finally, our Targets involves the target we want our package to know about and its dependencies. So here we are depending on our `my-framework.xcframework` binary locally, and then we need to tell the target about the package dependency we fetch from *Github*. We also need to tell our target where our **XCFramework** is located in the `binaryTarget`


Once we create our Swift Package, as describe above, we have 2 options.

1. Depend on it Locally by dragging the Swift Package into the project and make sure the Binary is linked in the target.
2. Commit our Swift Package to a git repo and have our iOS client fetch it from there.
We can fetch remote code from our iOS Project by doing the following:
```
1. In your Xcode Project, select File > Swift Packages > Add Package Dependency
2. Follow the prompts using the URL for this repository
3. Choose which version you would like to checkout (i.e. 4.0.0)
```


## Creating an XCFramework

In order to create an XCFramework that supports a variety of Archetectures we recommend using a shell script to Archive your project's target and then create the XCFramework. So in the root of your Framework or Static Library Create a file and call it something like `build.sh` 

Here is an example of what `build.sh` need to have inside of it

### Note
You need to make sure that in your project in the Xcode Build Settings these 2 settings are set accordingly
```
SKIP_INSTALL=NO
```
```
BUILD_LIBRARY_FOR_DISTRIBUTION=YES
```

```
#!/bin/zsh

xcodebuild archive \
-project YourProject.xcodeproj \
-scheme YourProjectTarget \
-archivePath target/xcodebuild/device.xcarchive \
-destination "generic/platform=iOS" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
ARCHS="arm64" \
IPHONEOS_DEPLOYMENT_TARGET=12.0 \
# If you want to enable bitcode these are the lines you need
ENABLE_BITCODE=YES \

# Simulator builds don't have bitcode abilities
xcodebuild archive \
-project YourProject.xcodeproj \
-scheme YourProject \
-archivePath build/simulator.xcarchive \
-destination "generic/platform=iOS Simulator" \
SKIP_INSTALL=NO \
ARCHS="arm64" \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
IPHONEOS_DEPLOYMENT_TARGET=12.0 

#Time to create an XCFramework with device and simulator for a Static Library
xcodebuild -create-xcframework \
-library build/device.xcarchive/Products/usr/local/lib/libYourFramework.a \
-headers build/device.xcarchive/Products/usr/local/include \
-library build/simulator.xcarchive/Products/usr/local/lib/libYourFramework.a \
-headers build/simulator.xcarchive/Products/usr/local/include \
-output build/YourFramework.xcframework
```

If you want to create an XCFramework from a Framework instead replace the above code with something like this

```
xcodebuild -create-xcframework \
-framework build/device.xcarchive/Products/Library/Frameworks/YourFramework.framework \
-framework build/simulator.xcarchive/Products/Library/Frameworks/YourFramework.framework \
-output build/YourFramework.xcframework
```

Then you can just run the shell script in it's directory
`sh build.sh`
You should have an XCFramework inside of the build folder indicated in `-output`
