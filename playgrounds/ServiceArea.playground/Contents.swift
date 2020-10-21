
import Foundation
import CoreLocation

struct EmptyResponse: Decodable {}

struct ServiceArea: Decodable {

    enum CodingKeys: String, CodingKey {
        case regions = "coordinates"
    }

    /// These are the holes we cut out from the world polygon. Consider their holes as islands that have to be drawn as
    /// separate polygons without holes.
    let regions: [Polygon]
}

extension ServiceArea {

    static let worldCoordinates = LinearRing(coordinates: [
        CLLocationCoordinate2D(latitude: 85, longitude: 90),
        CLLocationCoordinate2D(latitude: 85, longitude: 0.1),
        CLLocationCoordinate2D(latitude: 85, longitude: -90),
        CLLocationCoordinate2D(latitude: 85, longitude: -179.9),
        CLLocationCoordinate2D(latitude: 0, longitude: -179.9),
        CLLocationCoordinate2D(latitude: -85, longitude: -179.9),
        CLLocationCoordinate2D(latitude: -85, longitude: -90),
        CLLocationCoordinate2D(latitude: -85, longitude: 0.1),
        CLLocationCoordinate2D(latitude: -85, longitude: 90),
        CLLocationCoordinate2D(latitude: -85, longitude: 179.9),
        CLLocationCoordinate2D(latitude: 0, longitude: 179.9),
        CLLocationCoordinate2D(latitude: 85, longitude: 179.9)
    ])

    /// A LinearRing that can contain holes
    struct Polygon: Decodable {
        let outerRing: LinearRing
        let holes: [LinearRing]

        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            var linearRings: [LinearRing] = []

            while !container.isAtEnd {
                do {
                    let ring = try container.decode(LinearRing.self)
                    linearRings.append(ring)
                } catch {
                    _ = try container.decode(EmptyResponse.self) // skip undecodable item
                }
            }
            outerRing = linearRings.first ?? LinearRing()
            holes = Array(linearRings.dropFirst())
        }
    }

    /// A simple array of coordinates. It cannot conatin holes like polygons
    struct LinearRing: Decodable {
        let coordinates: [CLLocationCoordinate2D]

        init(coordinates: [CLLocationCoordinate2D] = []) {
            self.coordinates = coordinates
        }

        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            var coordinates: [[CLLocationDegrees]] = []

            while !container.isAtEnd {
                do {
                    let latLngArray = Array(try container.decode([CLLocationDegrees].self))
                    guard latLngArray.count == 2, let lat = latLngArray.first, let lng = latLngArray.last else { continue }
                    coordinates.append([lat, lng])
                } catch {
                    _ = try container.decode(EmptyResponse.self) // skip undecodable item
                }
            }
            self.coordinates = Array(coordinates
                .map { CLLocationCoordinate2D(latitude: $0[0], longitude: $0[1]) })
        }
    }
}

let decoder = JSONDecoder()
let geoJsonPath = Bundle.main.path(forResource: "geo_01", ofType: "json")!
let data = FileManager.default.contents(atPath: geoJsonPath)!

let serviceArea = try decoder.decode(ServiceArea.self, from: data)
serviceArea.regions.forEach { print("\($0)\n\n") }
print("Regions: \(serviceArea.regions.count)")


