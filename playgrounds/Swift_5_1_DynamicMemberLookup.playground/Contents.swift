import UIKit

struct Common: Equatable {

    let id: String
    let type: String
    let createdAt: Date
    let updatedAt: Date
    let version: Int
}

protocol CommonProtocol {
    var common: Common { get }
}

extension CommonProtocol {
    public subscript<T> (dynamicMember keyPath: KeyPath<Common, T>) -> T {
        common[keyPath: keyPath]
    }
}

@dynamicMemberLookup
struct User: Equatable, CommonProtocol {

    let firstName: String
    let lastName: String
    let common: Common
}

let common = Common(id: "", type: "", createdAt: Date(), updatedAt: Date(), version: 0)
let user = User(firstName: "John", lastName: "Doe", common: common)


user.createdAt
