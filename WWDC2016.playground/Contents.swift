//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


// ------- Extension on a String typed array     ------

var str = ["Hello", "playground"]
extension Collection where Iterator.Element == String {
    func dump() -> String {
        return joined(separator: ",\n")
    }
}
str.dump()


// ------- Playground live View     ------

let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667)) // iPhone 6 proportions
view.backgroundColor = UIColor.gray

let textField = UITextField(frame: CGRect(x: 20, y: 60, width: 300, height: 44))
textField.placeholder = "Edit me…"
textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
textField.textColor = UIColor.white
textField.isUserInteractionEnabled = true
textField.textContentType = .fullStreetAddress
view.addSubview(textField)

PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true


// ------- Different Class and Instance Type's     ------

let name = "Stefan"
let instanceValue = name.self
let instanceType = type(of: name) // same as name.dynamicType in Swift 2
let classType = String.self


// ------- Formatting Person Names     ------

let personNameFormatter = PersonNameComponentsFormatter()
var personNameComponents = personNameFormatter.personNameComponents(from: "Viana Fernandez de Bastida, Andrea")
var givenName = personNameComponents?.givenName
var middleName = personNameComponents?.middleName
var familyName = personNameComponents?.familyName

personNameComponents = personNameFormatter.personNameComponents(from: "Andrea Viana Fernandez de Bastida")
givenName = personNameComponents?.givenName
middleName = personNameComponents?.middleName
familyName = personNameComponents?.familyName


// ------- Formatting Units     ------

var roomTemperatureC = Measurement(value: 20, unit: UnitTemperature.celsius)
let roomTemperatureF = roomTemperatureC.converted(to: UnitTemperature.fahrenheit)
let roomTemperatureK = roomTemperatureC.converted(to: UnitTemperature.kelvin)
let additionalTemperatureC = Measurement(value: 1, unit: UnitTemperature.celsius)
let additionalTemperatureF = additionalTemperatureC.converted(to: UnitTemperature.fahrenheit)
let additionalTemperatureK = additionalTemperatureC.converted(to: UnitTemperature.kelvin)
let sumTemperatureK = roomTemperatureC + additionalTemperatureF
let sumTemperatureCWRONG = sumTemperatureK.converted(to: UnitTemperature.celsius)
let sumTemperatureCCORRECT = sumTemperatureCWRONG - Measurement(value: 273.15, unit: UnitTemperature.celsius)

let measurementFormatter = MeasurementFormatter()
measurementFormatter.locale = Locale(identifier: "en_US")
let enUSRoomTemperature = measurementFormatter.string(from: roomTemperatureC)

