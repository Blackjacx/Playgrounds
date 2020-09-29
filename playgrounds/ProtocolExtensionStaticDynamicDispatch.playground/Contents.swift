import UIKit

// https://dmtopolog.com/protocol-extensions/

protocol NewsProvider {
    var name: String { get }
}

extension NewsProvider {
    // Default implementation
    var name: String { "" }
    // Additional functionality
    var age: Int { 18 }
}

struct Foo: NewsProvider {
    var name: String = "Foo"
    var age: Int = 30
}

let foo: Foo = Foo()
let bar: NewsProvider = Foo()

// Dynamic method dispatch
foo.name // Foo
bar.name // Foo

// Static method dispatch
foo.age // 30
bar.age // 18
