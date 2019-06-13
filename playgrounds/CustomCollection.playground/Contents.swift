//: Playground - noun: a place where people can play

import Foundation

// https://www.swiftbysundell.com/posts/creating-custom-collections-in-swift utm_campaign=iOS%2BDev%2BWeekly&utm_medium=web&utm_source=iOS_Dev_Weekly_Issue_319
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Ordered%20Set/AppleOrderedSet.swift

var decimal = Decimal(floatLiteral: 9.94999999999)
var decimalResult = Decimal()
NSDecimalRound(&decimalResult, &decimal, 5, NSDecimalNumber.RoundingMode.down)
Double(truncating: decimalResult as NSNumber)
//Output: 9.94999999999, 9.949999999999999

struct OrderedSet<T: Hashable>: ExpressibleByArrayLiteral {

    typealias ListType = [T]

    private var objects: ListType = []
    private var indexOfKey: [T: Int] = [:]

    public mutating func append(_ object: T) {
        guard indexOfKey[object] == nil else {
            return
        }
        objects.append(object)
        indexOfKey[object] = objects.count - 1
    }

    public func object(at index: Int) -> T {
        return objects[index]
    }

    public mutating func insert(_ object: T, at index: Int) {
        assert(index < objects.count, "Index should be smaller than object count")
        assert(index >= 0, "Index should be bigger than 0")

        guard indexOfKey[object] == nil else {
            return
        }

        objects.insert(object, at: index)
        indexOfKey[object] = index
        for i in index+1..<objects.count {
            indexOfKey[objects[i]] = i
        }
    }

    public mutating func set(_ object: T, at index: Int) {
        assert(index < objects.count, "Index should be smaller than object count")
        assert(index >= 0, "Index should be bigger than 0")

        guard indexOfKey[object] == nil else {
            return
        }

        indexOfKey.removeValue(forKey: objects[index])
        indexOfKey[object] = index
        objects[index] = object
    }

    public func indexOf(_ object: T) -> Int {
        return indexOfKey[object] ?? -1
    }

    public mutating func remove(_ object: T) {
        guard let index = indexOfKey[object] else {
            return
        }

        indexOfKey.removeValue(forKey: object)
        objects.remove(at: index)
        for i in index..<objects.count {
            indexOfKey[objects[i]] = i
        }
    }


    // MARK: - ExpressibleByArrayLiteral

    /// The type of the elements of an array literal.
    typealias ArrayLiteralElement = T

    /// Creates an instance initialized with the given elements.
    init(arrayLiteral elements: ArrayLiteralElement...) {
        for element in elements {
            append(element)
        }
    }
}

extension OrderedSet: Collection {
    // Required nested types, that tell Swift what our collection contains
    typealias Index = ListType.Index
    typealias Element = ListType.Element

    // The upper and lower bounds of the collection, used in iterations
    var startIndex: Index { return objects.startIndex }
    var endIndex: Index { return objects.endIndex }

    // Required subscript, based on an array index
    subscript(index: Index) -> Iterator.Element {
        get { return objects[index] }
        set { objects[index] = newValue }
    }

    // Method that returns the next index when iterating
    func index(after i: Index) -> Index {
        return objects.index(after: i)
    }
}

var history: OrderedSet<Int> = [0]
history.append(1)
history.count
print(history)
history.contains(0)
