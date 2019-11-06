import Foundation

// MARK: - Range

let normalRange: Range = 1..<3
var myArray = ["a", "b", "c", "d", "e"]
myArray[normalRange] // ["b", "c"]

// MARK: - ClosedRange

let closedRange: ClosedRange = 1...3
myArray = ["a", "b", "c", "d", "e"]
myArray[closedRange] // ["b", "c", "d"]

// MARK: - CountableRange

let countableRange: CountableRange = 1..<3
myArray = ["a", "b", "c", "d", "e"]
myArray[countableRange] // ["b", "c"]

for index in countableRange {
    print(myArray[index])
}
print("-----------------------------------------------------------------------")

// MARK: - CountableClosedRange

let countableClosedRange: CountableClosedRange = 1...3
myArray = ["a", "b", "c", "d", "e"]
myArray[countableClosedRange] // ["b", "c", "d"]

for index in countableClosedRange {
    print(myArray[index])
}
print("-----------------------------------------------------------------------")

// MARK: - Open Ranges

let names = ["Hans", "Emmy", "Helge"]

// iterate from index 2 to the end of the array
for name in names[2...] {
    print(name)
}
print("-----------------------------------------------------------------------")

// iterate from the beginning of the array to index 2
for name in names[...2] {
    print(name)
}
print("-----------------------------------------------------------------------")

// iterate from the beginning of the array up to but not including index 2
for name in names[..<2] {
    print(name)
}
print("-----------------------------------------------------------------------")

// the range from negative infinity to 5. You can't iterate forward over this
// because the starting point in unknown.
let negativeInfinityRange = ...5
negativeInfinityRange.contains(7)   // false
negativeInfinityRange.contains(4)   // true
negativeInfinityRange.contains(-1)  // true

// You can iterate over this but it will be an infinate loop so you have to
// break out at some point.
let positiveInfinityRange = 5...
