import UIKit

let validOptions: Set<String> = Set(["A", "B"])
let disjointSet: Set<String> = Set(["C"])
let strictSubset: Set<String> = Set(["A"])
let subset: Set<String> = Set(["A", "B"])
let emptySet: Set<String> = Set([])

validOptions.isDisjoint(with: emptySet) // true
validOptions.isDisjoint(with: disjointSet) // true
validOptions.isDisjoint(with: strictSubset) // false
validOptions.isDisjoint(with: subset) // false
emptySet.isDisjoint(with: emptySet) // true
