import UIKit
import PlaygroundSupport

/*
 TODOS
 - network request logging
 - network request logging
 */

let accessToken = "x5WeQKZ46BGXkg9DEnhY67Pv"
let clientIdentifier = "beiwagen-ios"
let clientSecret = "rQ66kAdCE374cuVXUQTKDWKc" // DBFFM
let clientVersion = "2.4.0"
let apiVersion = "1"

enum IokiService {
    case readUser
}

extension IokiService: Endpoint {
    var scheme: String { return "https" }
    var host: String { return "staging.io.ki" }

    var path: String {
        let path: String
        switch self {
        case .readUser: path = "user"
        }
        return "/api/passenger/\(path)"
    }

    var headers: [String: String] {
        var headers: [String: String] = [
            "X-Api-Version": apiVersion,
            "X-Client-Identifier": clientIdentifier,
            "X-Client-Secret": clientSecret,
            "X-Client-Version": clientVersion
        ]

        // Sign all non-authenticating requests
        if shouldAuthorize {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        return headers
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .readUser: return .get
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .readUser: return .json
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .readUser: return nil
        }
    }

    var shouldAuthorize: Bool {
        switch self {
        case .readUser: return true
        }
    }

    var acceptableStatusCodes: Set<Int> {
        return Set(200...399)
    }
}

let task = IokiService.readUser.request { (result: RequestResult<User>) in

    switch result {
    case let .success(model): print(model)
    case let .failure(error): print(error)
    }
}
task.resume()

