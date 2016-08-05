//: Playground - noun: a place where people can play

import UIKit

enum VendingMachineError: ErrorType {
    case InvalidSelection
    case InsufficientFunds(coinsNeeded: Int)
    case OutOfStock
}

func vend(input: String?) throws {
    guard input != nil else {
        throw VendingMachineError.InvalidSelection
    }
}


func testVend() {
    do {
        try vend(nil)
        print("Success")
        
    } catch VendingMachineError.InvalidSelection {
        print("Fail 1")
    } catch {
        print("Fail 2 \(error)")
    }
}

testVend()




func testString() {
    do {
        try NSString(contentsOfFile: "Foo.bar", encoding: NSUTF8StringEncoding)
    }
    catch let error as NSError {
        print(error.localizedDescription)
    }
}


testString()