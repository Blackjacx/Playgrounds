//: Playground - noun: a place where people can play

import UIKit

enum PropertyIteratorError: ErrorType {
    case UnsupportedDisplayStyle
}

typealias Property = (name: String, value: Any)

protocol PropertyIterator {
    func properties() throws -> [Property]
}

extension PropertyIterator {
    
    func properties() throws -> [Property] {
        
        var result = [Property]()
        
        let mirror = Mirror(reflecting: self)

        guard let style = mirror.displayStyle where style == .Struct || style == .Class else {
            throw PropertyIteratorError.UnsupportedDisplayStyle
        }
        
        for (label, value) in mirror.children {
            guard let name = label else {
                continue
            }
            result.append((name, value))
        }
        
        return result
    }
}

struct ReuseID : PropertyIterator {
    let prepaidRechargeCreditCell = "PrepaidRechargeCreditCell"
    let threeTitledIconCell = "IconCellWith3Titles"
    let usageCell = "ListElementRingViewCell"
    let detailsCell = "ListElementStandardViewCell"
    let phoneNumberCell = "PhoneNumberCell"
}

do {
    debugPrint(try ReuseID().properties())
} catch {
    
}