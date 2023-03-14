# Constants

Constant things useful for FCSDK. LoggingLevel is especially helpful for setting how much information you can receive for debugging FCSDK applications. Please see <doc:FCSDKExtras> for more information.

## Overview

```swift
/// Constants
@objc final public class Constants : NSObject {

    /// The Version of the SDK
    @objc public static let SDK_VERSION_NUMBER: String
    /// WebSocket connection timeout
    @objc public static var WEBSOCKET_CONNECTION_TIMEOUT: Float

    override dynamic public init()
}

@objc public enum LoggingLevel : Int {

    case trace

    case debug

    case info

    case notice

    case warning

    case error

    case critical

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
    public init?(rawValue: Int)

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int

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
    public var rawValue: Int { get }
}

extension LoggingLevel : Equatable {
}

extension LoggingLevel : Hashable {
}

extension LoggingLevel : RawRepresentable {
}
```
