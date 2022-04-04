# ACBVideoCapture

An enumeration of Video Capture resolutions.

## Overview

```swift
/// Available Resolutions
@objc public enum ACBVideoCapture : Int, Comparable {

    /// automatic resolution best for the device
    case resolutionAuto

    /// 352px by 288px
    case resolution352x288

    /// 640px by 480px
    case resolution640x480

    /// 1280px by 720px
    case resolution1280x720
}

extension ACBVideoCapture : CaseIterable {

    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [FCSDKiOS.ACBVideoCapture]

    /// A collection of all values of this type.
    public static var allCases: [FCSDKiOS.ACBVideoCapture] { get }
}

extension ACBVideoCapture : RawRepresentable {

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = String

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: FCSDKiOS.ACBVideoCapture.RawValue { get }

    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional("PaperSize.Legal")"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init?(rawValue: String)

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func < (lhs: FCSDKiOS.ACBVideoCapture, rhs: FCSDKiOS.ACBVideoCapture) -> Bool
}

extension ACBVideoCapture : Hashable {
}

/// This class is used to set the Video Capture Settings, such as `resolution` and `frameRate`.
@objc final public class ACBVideoCaptureSetting : NSObject {

    /// The resolution to be set. See ``ACBVideoCapture``
    @objc final public var resolution: FCSDKiOS.ACBVideoCapture { get }

    /// An interger value to set as the frameRate
    @objc final public var frameRate: UInt { get }

    /// We want to return the size for our capture resolution from our available resolutions
    /// - Parameter resolution: The ``RawValue`` of a ``ACBVideoCapture``'s resolution
    /// - Returns: ``CGSize``
    @objc final public class func sizeForVideoCaptureResolution(resolution: FCSDKiOS.ACBVideoCapture.RawValue) -> CGSize
}
```
