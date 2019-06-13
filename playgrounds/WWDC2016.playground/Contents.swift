/*
 * This playground demonstrates some new techniques I found most interesting during watching WWDC 2016 videos.
 */

import UIKit
import PlaygroundSupport

/*
 * SWIFT3 PARAMETERS
 */

func swift3ParameterTest(param1: Int, param2: Int) {}
swift3ParameterTest(param1: 5, param2: 5)


/*
 * EXTENSION ON A TYPED ARRAY
 */

var str = ["Hello", "playground"]
extension Collection where Iterator.Element == String {
    func dump() -> String {
        return joined(separator: ",\n")
    }
}
str.dump()


/*
 * PLAYGROUND LIVE VIEW
 */

let margin: CGFloat = 11.0
let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667)) // iPhone 6 proportions
view.backgroundColor = UIColor.gray

let textField = UITextField()
textField.translatesAutoresizingMaskIntoConstraints = false
textField.placeholder = "Edit me…"
textField.backgroundColor = UIColor(white: 1, alpha: 1.0)
textField.textColor = UIColor.white
textField.isUserInteractionEnabled = true
textField.textContentType = .fullStreetAddress
view.addSubview(textField)

var constraints: [NSLayoutConstraint] = []
let tfLeftConstraint = textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin)
constraints.append(tfLeftConstraint)
let tfRightConstraint = textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin)
constraints.append(tfRightConstraint)
let tfTopConstraint = textField.topAnchor.constraint(equalTo: view.topAnchor, constant: margin)
constraints.append(tfTopConstraint)
let tfHeightConstraint = textField.heightAnchor.constraint(equalToConstant: 44.0)
constraints.append(tfHeightConstraint)

NSLayoutConstraint.activate(constraints)

PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true


/*
 * DIFFERENT CLASS AND INSTANCE TYPE`S
 */

let name = "Stefan"
let instanceValue = name.self
let instanceType = type(of: name) // same as name.dynamicType in Swift 2
let classType = String.self


/*
 * FORMATTING PERSON NAMES
 *
 * There is now the new PersonNameComponentsFormatter that is able to format 
 * even complex names no matter if they are written in reversed order.
 */

let personNameFormatter = PersonNameComponentsFormatter()
var personNameComponents = personNameFormatter.personNameComponents(from: "Viana Fernandez de Bastida, Andrea")
personNameComponents = personNameFormatter.personNameComponents(from: "Andrea Viana Fernandez de Bastida")
personNameComponents = personNameFormatter.personNameComponents(from: "Markus Maria Müller")


/*
 * FORMATTING UNITS
 */

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
