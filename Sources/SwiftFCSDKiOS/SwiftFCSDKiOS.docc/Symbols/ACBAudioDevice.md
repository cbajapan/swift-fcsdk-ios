# ACBAudioDevice

ACBAudioDevice provides available device audio capabilities. Please see <doc:ACBAudioDeviceManager> for instructions on how to set the device capability.


## Overview

```swift
    /// Available AudioDevices
    @objc public enum ACBAudioDevice : Int, Comparable {
    
        /// speaker phone enabled
        case speakerphone
    
        /// wired headset enabled
        case wiredHeadset
    
        /// earpiece enabled
        case earpiece
    
        /// bluetooth enabled
        case bluetooth
    
        /// no audio device
        case none
    }
    
    extension ACBAudioDevice : CaseIterable {
    
        /// A type that can represent a collection of all values of this type.
        public typealias AllCases = [FCSDKiOS.ACBAudioDevice]
    
        /// A collection of all values of this type.
        public static var allCases: [FCSDKiOS.ACBAudioDevice] { get }
    }
    
    extension ACBAudioDevice : RawRepresentable {
    
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
        public var rawValue: FCSDKiOS.ACBAudioDevice.RawValue { get }
    
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
        public static func < (lhs: FCSDKiOS.ACBAudioDevice, rhs: FCSDKiOS.ACBAudioDevice) -> Bool
    }
    
    extension ACBAudioDevice : Hashable {
    }
```
