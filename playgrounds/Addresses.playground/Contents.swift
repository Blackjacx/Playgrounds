import UIKit
import Contacts
import AddressBook
import AddressBookUI
import MapKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let coordinate = CLLocationCoordinate2D(latitude: 51.4974711, longitude: -0.1285036)
var addressDictionary: [String : String] = [:]

addressDictionary["Name"] = "Mainzer Landstraße 1, 60325 Frankfurt am Main, Hessen, Deutschland"

addressDictionary["Thoroughfare"] = "Mainzer Landstraße"
addressDictionary["Street"] = "Mainzer Landstraße 1"

addressDictionary["SubThoroughfare"] = "1"

addressDictionary["City"] = "Frankfurt am Main"
addressDictionary["Locality"] = "Frankfurt am Main"
addressDictionary["SubAdministrativeArea"] = "Frankfurt am Main"

addressDictionary["ZIP"] = "60325"

addressDictionary["SubLocality"] = "Gallus"

addressDictionary["AdministrativeArea"] = "Hessen"
addressDictionary["State"] = "Hessen"

addressDictionary["Country"] = "Deutschland"

addressDictionary["CountryCode"] = "DE"

let mkPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
mkPlacemark.postalAddress
ABCreateStringWithAddressDictionary(addressDictionary, true)


let geocoder = CLGeocoder()
let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

geocoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in

    guard let firstPlace = placemarks?.first else {
        print("Nothing found!")
        return
    }

    firstPlace.addressDictionary?.forEach { (key, value) in
        print("\(key): \(value)")
    }
}


// =================

struct Address {
    public let coordinate: CLLocationCoordinate2D
    public let name: String
    public let street: String
    public let streetNumber: String
    public let streetWithNumber: String
    public let zip: String
    public let city: String
    public let state: String
    public let country: String

    public func localizedAddress(
        makeSingleLined: Bool = true,
        useState: Bool = false,
        useCountry: Bool = false,
        useZip: Bool = false,
        useCity: Bool = true) -> String {

        let address = CNMutablePostalAddress()
        address.street = streetWithNumber

        if useState { address.state = state }
        if useCountry { address.country = country }
        if useZip { address.postalCode = zip }
        if useCity { address.city = city }

        let addressString = CNPostalAddressFormatter.string(from: address, style: .mailingAddress)

        guard makeSingleLined else { return addressString }

        return addressString
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}

