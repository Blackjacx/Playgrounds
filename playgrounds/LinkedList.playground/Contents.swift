import Foundation

//**********************************************************************************************************************
//
// Swifty Enum-Powered Linked List
//
//**********************************************************************************************************************

/*
 https://gist.github.com/avdyushin/673b1b5523cc3ad66669
 */

indirect enum Linked<T: Equatable>: Equatable {
    case empty
    case node(value: T, next: Linked<T> = .empty)

    init() { self = .empty }

    init(_ values: [T]) {
        var list = Linked()
        values.forEach { list.append(item: $0) }
        self = list
    }
}

extension Linked: CustomStringConvertible {

    /// Recursively print all 👌
    var description: String {
        switch self {
        case .empty: return "empty"
        case let .node(value, next): return "\(value) -> \(next)"
        }
    }
}

extension Linked {
    mutating func append(item: T) {
        self = Self.recursiveAppend(item: item, head: self)
    }

    private static func recursiveAppend(item: T, head: Linked) -> Linked {
        switch head {
        case .empty: return .node(value: item)
        case let .node(value, next): return .node(value: value, next: recursiveAppend(item: item, head: next))
        }
    }
}

var linked = Linked<Int>([5, 6, 7, 8, 9])
print(linked)

//**********************************************************************************************************************
//
// Standard Linked List (Interview Style)
//
//**********************************************************************************************************************

class LinkedList<T: Equatable>: CustomStringConvertible {
    var value: T
    var next: LinkedList?

    init(value: T, next: LinkedList? = nil) {
        self.value = value
        self.next = next
    }

    init?(values: [T]) {
        var iterator = values.makeIterator()
        var result: LinkedList?
        while let next = iterator.next() {
            guard result != nil else { result = LinkedList(value: next); continue }
            result?.append(next)
        }
        guard let first = result else { return nil }
        value = first.value
        next = first.next
    }

    var description: String {
        String(describing: value)
    }

    func printAll() {
        var current: LinkedList? = self
        while let c = current {
            print("\(c)")
            current = c.next
        }
    }

    func append(_ element: LinkedList) {
        var current: LinkedList? = self
        while current?.next != nil {
            current = current?.next
        }
        current?.next = element
    }

    func append(_ value: T) {
        append(LinkedList(value: value))
    }

    func deleteAll(of value: T, previous: LinkedList?, current: LinkedList?, head: LinkedList?) -> LinkedList? {

        // Finished
        guard let current = current else { return head }

        // Advance
        guard current.value == value else {
            return deleteAll(of: value, previous: current, current: current.next, head: head)
        }

        /*
         Equality detected
         */

        if previous == nil {
            // Increment head pointer
            return deleteAll(of: value, previous: previous, current: current.next, head: current.next)
        } else {
            // Drop current element
            previous?.next = current.next
            return deleteAll(of: value, previous: previous, current: current.next, head: head)
        }
    }
}

var list1 = LinkedList(values: [0, 1, 2, 3])
list1?.deleteAll(of: 0, previous: nil, current: list1, head: list1)?.printAll()

print("---------------------------")

var list2 = LinkedList(values: [0, 1, 2, 3])
list2?.deleteAll(of: 3, previous: nil, current: list2, head: list2)?.printAll()

print("---------------------------")

var list3 = LinkedList(values: [1, 1, 1])
list3?.deleteAll(of: 1, previous: nil, current: list3, head: list3)?.printAll()
