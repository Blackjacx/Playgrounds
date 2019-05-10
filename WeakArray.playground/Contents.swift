import UIKit

final class RideHandler {
    static var instanceCount: Int { return instances.count }
    private static var instances: [WeakBox<RideHandler>] = []

    let id: String

    init() {
        id = NSUUID().uuidString
        RideHandler.instances.append( WeakBox(self) )
        print("Added \(self.id)")
    }

    deinit {
        RideHandler.instances = RideHandler.instances.filter { $0 === self }
        print("Removed \(self.id)")
    }
}

var handler1: RideHandler? = RideHandler()
var handler2: RideHandler? = RideHandler()

print("RideHandler instances: \(RideHandler.instanceCount)")

handler1 = nil
handler2 = nil





// https://www.objc.io/blog/2017/12/28/weak-arrays/

final class WeakBox<A: AnyObject> {
    weak var unbox: A?
    init(_ value: A) {
        unbox = value
    }
}
