import Foundation

public enum RequestError: Error {
    case timeout
    case noInternetConnection
    case decodingError(_ error: Error)
    case invalidResponse(_ response: URLResponse?)
    case generic(_ error: Error)

    static func mapError(_ error: Error) -> RequestError {

        if (error as NSError).code == -1009 {
            return .noInternetConnection
        }
        return generic(error)
    }
}
