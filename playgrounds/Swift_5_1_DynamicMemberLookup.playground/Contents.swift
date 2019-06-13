import UIKit

struct Common: Equatable {

    let id: String
    let type: String
    let createdAt: Date
    let updatedAt: Date
    let version: Int
}

@dynamicMemberLookup
struct User: Equatable {

    let firstName: String
    let lastName: String
    let common: Common

    public subscript<T> (dynamicMember keyPath: KeyPath<Common, T>) -> T {
        common[keyPath: keyPath]
    }
}

let common = Common(id: "", type: "", createdAt: Date(), updatedAt: Date(), version: 0)
let user = User(firstName: "John", lastName: "Doe", common: common)
