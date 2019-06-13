import Foundation

public struct DataWrapper<T: Decodable>: Decodable {

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    public let data: T
}


public struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case isRegistered = "registered"
        case hasTermsAccepted = "current_terms_accepted"
    }

    public let firstName: String
    public let lastName: String
    public let phoneNumber: String
    public let isRegistered: Bool
    public let hasTermsAccepted: Bool
}
