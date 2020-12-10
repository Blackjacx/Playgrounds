import UIKit

// https://www.hackingwithswift.com/articles/218/whats-new-in-swift-5-3
//
// SE-0280 allows enums to participate in protocol witness matching, which is a technical way of saying they can now
// match requirements of protocols more easily.

protocol PurchasableItem {
    static var discount: Self { get }
    static var credit: Self { get }
}

protocol PurchasableItemExtended: PurchasableItem {
    static var ride: Self { get }
}

enum ItemType: PurchasableItem {
    case discount
    case credit
}

enum ItemTypeExt: PurchasableItemExtended {
    case ride
    case discount
    case credit
}
