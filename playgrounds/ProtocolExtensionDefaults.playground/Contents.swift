import UIKit

protocol MyFancyProtocol {
    var name: String {get}
}

extension MyFancyProtocol {
    var name: String {return "Extension"}
}

struct Implementation: MyFancyProtocol {
    var name: String {return "Implementation"}
}

struct Mock: MyFancyProtocol {
    var name: String {return "Mock"}
}

struct Fallback: MyFancyProtocol {
}

func printName(_ obj: MyFancyProtocol) {
    print(obj.name)
}

printName(Implementation())
printName(Mock())
printName(Fallback())
