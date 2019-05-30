import Foundation

// *****************************************************************************
// Many thanks to Erica Sadun for describing the new possibilities of string
// interpolation in Swift 5 👍
// *****************************************************************************


// *****************************************************************************
// Conditional Interpolation

struct Contact {
    let name: String
    let isFavorite: Bool
}
let me = Contact(name: "Stefan", isFavorite: true)

// ***************************************************************** Swift 4

var message = "Contact \(me.name)"
if me.isFavorite {
    message.append(" is favorite")
}
message // we need 4 lines to construct this message!!!
"Contact: \(me.name)\(me.isFavorite ? " is favorite" : "")" // or a complex ternary operator

// ***************************************************************** Swift 5

extension String.StringInterpolation {

    mutating func appendInterpolation(if condition: @autoclosure () -> Bool, _ literal: StringLiteralType) {
        guard condition() else { return }
        appendLiteral(literal)
    }
}
"Contact: \(me.name)\(if: me.isFavorite, " is favorite")" // simple and clean - no extras

// *****************************************************************************
// Optional Interpolation

let optionalMe: Contact? = Contact(name: "Stefan", isFavorite: true)

// ***************************************************************** Swift 4

"Contact: \(optionalMe?.name)" // shows warning

// ***************************************************************** Swift 5

// Interpolate nil value
extension String.StringInterpolation {
    /// Provides `Optional` string interpolation without forcing the
    /// use of `String(describing:)`.
    public mutating func appendInterpolation<T>(_ value: T?, default defaultValue: String) {
        if let value = value {
            appendInterpolation(value)
        } else {
            appendLiteral(defaultValue)
        }
    }
}
let nilContact: Contact? = nil
"Contact: \(nilContact?.name, default: "nil")"

// Strip `Optional`
extension String.StringInterpolation {
    /// Interpolates an optional using "stripped" interpolation, omitting
    /// the word "Optional" from both `.some` and `.none` cases
    public mutating func appendInterpolation<T>(describing value: T?) {
        if let value = value {
            appendInterpolation(value)
        } else {
            appendLiteral("nil")
        }
    }

}
"Contact: \(describing: optionalMe?.name)"
