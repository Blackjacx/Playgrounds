import UIKit

struct MixedPropertyStruct {

    static let shared = MixedPropertyStruct()
    static let allProperties: [String] = {
        Mirror(reflecting: shared).children.compactMap { $0.value as? String }
    }()

    static let allStaticProperties: [String] = {
        Mirror(reflecting: MixedPropertyStruct.self).children.compactMap { $0.value as? String }
    }()

    static let staticFoo = "static_foo"
    static let staticBar = "static_bar"

    let foo = "foo"
    let bar = "bar"
}

print(MixedPropertyStruct.allProperties)
print(MixedPropertyStruct.allStaticProperties)
