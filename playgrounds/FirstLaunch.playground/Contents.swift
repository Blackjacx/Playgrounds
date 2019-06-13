//: Playground - noun: a place where people can play

import UIKit

protocol FirstLaunchDataSource {

    func getWasLaunchedBefore() -> Bool
    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool)

}

class FirstLaunch {

    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }

    init(source: FirstLaunchDataSource) {
        let wasLaunchedBefore = source.getWasLaunchedBefore()
        self.wasLaunchedBefore = wasLaunchedBefore

        print(wasLaunchedBefore)

        if !wasLaunchedBefore {
            source.setWasLaunchedBefore(true)
        }
    }

}

struct AlwaysFirstLaunchDataSource : FirstLaunchDataSource {

    func getWasLaunchedBefore() -> Bool {
        return false
    }

    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool) {
        // do nothing
    }

}

extension UserDefaults: FirstLaunchDataSource {

    private var key: String { return "<your_user_defaults_key>" }

    func getWasLaunchedBefore() -> Bool {
        return bool(forKey: key)
    }

    func setWasLaunchedBefore(_ wasLaunchedBefore: Bool) {
        self.set(wasLaunchedBefore, forKey: key)
    }
}

let userDefaultsFirstLaunch = FirstLaunch(source: UserDefaults.standard)
print(userDefaultsFirstLaunch.wasLaunchedBefore)
