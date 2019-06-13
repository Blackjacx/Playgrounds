import UIKit

// MARK: - Interactor

public protocol Notifyable {
    var id: String { get }
    func notify(keyPath: AnyKeyPath, to newValue: Any)
}

struct Interactor: Notifyable {
    let id: String = NSUUID().uuidString

    init() {
    }

    func notify(keyPath: AnyKeyPath, to newValue: Any) {
        print("Update \(keyPath) to \(newValue)")
    }
}



// MARK: - Model

struct Model {
    static var paths: [AnyKeyPath: Notifyable] = [:]

    var name: String
    var sub: SubModel

    init(name: String, varCount: Int) {
        self.name = name
        self.sub = SubModel(varCount: varCount)
    }

    static func subscribe<T>(keyPath: KeyPath<Model, T>, listener: Notifyable) {
        paths[keyPath] = listener
    }

    static func unsubscribe<T>(listener: Notifyable, for keyPath: KeyPath<Model, T>?) {
        paths.forEach  {
            guard $0.value.id == listener.id else { return }
            guard let keyPath = keyPath else { paths[$0.key] = nil; return }
            guard keyPath == $0.key else { return }
            paths[keyPath] = nil
        }
    }

    static func update<T: Equatable>(model: inout Model, at keyPath: WritableKeyPath<Model, T>, with newValue: T) {
        let current = model[keyPath: keyPath]

        if current != newValue {
            model[keyPath: keyPath] = current
            paths.first { $0.key == keyPath }?.value.notify(keyPath: keyPath, to: newValue)
        }
    }
}

struct SubModel {
    var varCount: Int
}

var model = Model(name: "Stefan", varCount: 2)
let interactor = Interactor()

Model.subscribe(keyPath: \.name, listener: interactor)
Model.update(model: &model, at: \.name, with: "Hoshy") // sends notification
Model.update(model: &model, at: \.sub.varCount, with: 1) // no update info

