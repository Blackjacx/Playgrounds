//: Playground - noun: a place where people can play

import UIKit
import CoreLocation

let coordinates: [(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D)] = [
    (CLLocationCoordinate2D(latitude: 50.105179999999997, longitude: 8.6504200000000004),
     CLLocationCoordinate2D(latitude: 50.105179999999983, longitude: 8.6504200000000537)),

    (CLLocationCoordinate2D(latitude: 50.111070304979314, longitude: 8.6479353904724121),
     CLLocationCoordinate2D(latitude: 50.111070304979307, longitude: 8.6479353904723979)),

    (CLLocationCoordinate2D(latitude: 50.10517_9999999983, longitude: 8.64793_53904724121),
     CLLocationCoordinate2D(latitude: 50.10517_9999999997, longitude: 8.64793_53904723979)),

    (CLLocationCoordinate2D(latitude: 50.11762_3999999999, longitude: 8.66910_50000000001),
     CLLocationCoordinate2D(latitude: 50.11762_4000000006, longitude: 8.66910_50000000178))
]

let lhs = coordinates[3].lhs
let rhs = coordinates[3].rhs
let precision = 5

// MARK: - Extensions

public extension Double {

    func comparableRepresentation1() -> Double {
        let factor = pow(10, Double(precision))
        return Double(Int(self * factor)) / factor
    }

    func comparableRepresentation2() -> Double {

        var decimal = Decimal(self)
        var decimalResult = Decimal()
        NSDecimalRound(&decimalResult, &decimal, precision, NSDecimalNumber.RoundingMode.down)
        return Double(truncating: decimalResult as NSNumber)
    }

    func comparableRepresentation3() -> Double {

        let decimal = NSDecimalNumber(value: self)
        let handler = NSDecimalNumberHandler(roundingMode: .down, scale: Int16(precision), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let decimalResult = decimal.rounding(accordingToBehavior: handler)
        return Double(truncating: decimalResult as NSNumber)
    }

    func comparableRepresentation4() -> Double {
        return Double(Float(self))
    }

    func comparableRepresentation5() -> String {

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .down
        formatter.maximumFractionDigits = precision
        return formatter.string(from: self as NSNumber) ?? ""
    }
}

let result1: Bool = {
    let fLhsLat = lhs.latitude.comparableRepresentation1()
    let fRhsLat = rhs.latitude.comparableRepresentation1()
    let fLhsLng = lhs.longitude.comparableRepresentation1()
    let fRhsLng = rhs.longitude.comparableRepresentation1()

    return (fLhsLat == fRhsLat && fLhsLng == fRhsLng)
}()

let result2: Bool = {
    let fLhsLat = lhs.latitude.comparableRepresentation2()
    let fRhsLat = rhs.latitude.comparableRepresentation2()
    let fLhsLng = lhs.longitude.comparableRepresentation2()
    let fRhsLng = rhs.longitude.comparableRepresentation2()

    return (fLhsLat == fRhsLat && fLhsLng == fRhsLng)
}()

let result3: Bool = {
    let fLhsLat = lhs.latitude.comparableRepresentation3()
    let fRhsLat = rhs.latitude.comparableRepresentation3()
    let fLhsLng = lhs.longitude.comparableRepresentation3()
    let fRhsLng = rhs.longitude.comparableRepresentation3()

    return (fLhsLat == fRhsLat && fLhsLng == fRhsLng)
}()

let result4: Bool = {
    let fLhsLat = lhs.latitude.comparableRepresentation4()
    let fRhsLat = rhs.latitude.comparableRepresentation4()
    let fLhsLng = lhs.longitude.comparableRepresentation4()
    let fRhsLng = rhs.longitude.comparableRepresentation4()

    return (fLhsLat == fRhsLat && fLhsLng == fRhsLng)
}()

let result5: Bool = {
    let fLhsLat = lhs.latitude.comparableRepresentation5()
    let fRhsLat = rhs.latitude.comparableRepresentation5()
    let fLhsLng = lhs.longitude.comparableRepresentation5()
    let fRhsLng = rhs.longitude.comparableRepresentation5()

    return (fLhsLat == fRhsLat && fLhsLng == fRhsLng)
}()
