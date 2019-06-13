import UIKit

protocol TestProtocol {
    var name: String {get}
}
extension TestProtocol {
    var name: String {return "Extension"}
}

class TestClass: TestProtocol {
    init() {}
}

class TestSubClass: TestClass {
    var name: String {return "Subclass"}
}

let thing = TestSubClass()
thing.name //Returns "Other", as expected
let genericThing = thing
genericThing.name //Returns "Default", but would return "Other" in a base class
