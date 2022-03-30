# TopicData

An Object used for AED topics. Please see <doc:AED> for information.

## Overview
```swift
/// Properties are optional for encoding and decoding puposes as defined by FCSDK
/// We also need to be a class because Objective-C doesn't play well with `Structs``
@objc final public class TopicData : NSObject, Codable {

    @objc final public var key: String?

    @objc final public var value: String?

    /// Custom coding keys because the server is not consistent in case type
    public enum CodingKeys : String, CodingKey {

        case key

        case value

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

        /// Creates a new instance from the given string.
        ///
        /// If the string passed as `stringValue` does not correspond to any instance
        /// of this type, the result is `nil`.
        ///
        /// - parameter stringValue: The string value of the desired key.
        public init?(stringValue: String)

        /// Creates a new instance from the specified integer.
        ///
        /// If the value passed as `intValue` does not correspond to any instance of
        /// this type, the result is `nil`.
        ///
        /// - parameter intValue: The integer value of the desired key.
        public init?(intValue: Int)

        /// The raw type that can be used to represent all values of the conforming
        /// type.
        ///
        /// Every distinct value of the conforming type has a corresponding unique
        /// value of the `RawValue` type, but there may be values of the `RawValue`
        /// type that don't have a corresponding value of the conforming type.
        public typealias RawValue = String

        /// The value to use in an integer-indexed collection (e.g. an int-keyed
        /// dictionary).
        public var intValue: Int? { get }

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
        public var rawValue: String { get }

        /// The string to use in a named collection (e.g. a string-keyed dictionary).
        public var stringValue: String { get }
    }

    @objc public init(key: String, value: String)

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    required public init(from decoder: Decoder) throws

    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    final public func encode(to encoder: Encoder) throws
}

extension TopicData.CodingKeys : Equatable {
}

extension TopicData.CodingKeys : Hashable {
}

extension TopicData.CodingKeys : RawRepresentable {
}
```
