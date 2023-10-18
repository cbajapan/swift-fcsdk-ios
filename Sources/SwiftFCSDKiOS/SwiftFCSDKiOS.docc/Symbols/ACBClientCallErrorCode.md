# ACBClientCallErrorCode

An enumeration of call error codes

## Overview

```swift
    public enum ACBClientCallErrorCode : String, Error {
    
        /** Indicates that a general error has occurred when making an outgoing call. */
        case dialFailure
    
        /** Indicates that an attempt to make an outbound call failed because a call is already     in progress. */
        case dialFailureCallInProgress
    
        /** Indicates that a general error has occurred with an established call. */
        case callFailure
    
        /** Indicates that the call was in the wrong state when an answer has been received. */
        case wrongStateWhenAnswerReceived
    
        /** Indicates that a session description could not be created. */
        case sessionDescriptionCreationError
    }
    
    extension ACBClientCallErrorCode : CaseIterable {
    
        /// A type that can represent a collection of all values of this type.
        public typealias AllCases = [FCSDKiOS.ACBClientCallErrorCode]
    
        /// A collection of all values of this type.
        public static var allCases: [FCSDKiOS.ACBClientCallErrorCode] { get }
    }
    
    extension ACBClientCallErrorCode : RawRepresentable {
    
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
        public var rawValue: FCSDKiOS.ACBClientCallErrorCode.RawValue { get }
    
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
    
        public static func < (lhs: FCSDKiOS.ACBClientCallErrorCode, rhs:    FCSDKiOS.ACBClientCallErrorCode) -> Bool
    }
    
    extension ACBClientCallErrorCode : Equatable {
    }
    
    extension ACBClientCallErrorCode : Hashable {
    }
```
