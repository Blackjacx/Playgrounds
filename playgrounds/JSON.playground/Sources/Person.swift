import Foundation

public struct Person: Codable {
    public let name: String
    public let birthday: Date
    public let email: String?
    public let unavailableProperty: String?

    public var age: Int {
        Calendar.current.dateComponents([.year], from: birthday, to: Date()).year ?? 0
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.birthday = try container.decode(Date.self, forKey: .birthday)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.unavailableProperty = try container.decodeIfPresent(String.self, forKey: .unavailableProperty)
    }
}
