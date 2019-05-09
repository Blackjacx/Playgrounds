import Foundation

public typealias RequestResult<T: Decodable> = Result<T, RequestError>
public typealias RequestClosure<T: Decodable> = (RequestResult<T>) -> Void

public protocol Endpoint {

    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String] { get }
    var encoding: ParameterEncoding { get }
    var parameters: [String: Any]? { get }
    var shouldAuthorize: Bool { get }
    var acceptableStatusCodes: Set<Int> { get }
}

public extension Endpoint {

    var name: String {
        return "\(type(of: self))"
    }

    var sampleData: Data {
        return Data()
    }

    var urlRequest: URLRequest {

        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path

        switch encoding {
            #warning("Implement json encoding")
        case .json: break
        #warning("Implement url encoding somehow in the enum ParameterEncoding")
        case .url:
            guard let parameters = parameters, !parameters.isEmpty else { break }
            components.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }

        // We still have to keep 'url' as an optional, since we're dealing with
        // dynamic components that could be invalid.
        guard let url = components.url else {
            fatalError("Cannot construct URL from components: \(components)")
        }

        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10)
        request.allHTTPHeaderFields = headers
        request.httpMethod = httpMethod.rawValue
        return request
    }

    func request<T: Decodable>(completion: @escaping RequestClosure<T>) -> URLSessionTask {

        return URLSession.shared.dataTask(with: urlRequest) { ( rawData, response, error) in

            guard let data = rawData else {
                guard let error = error else {
                    print("No data")
                    return
                }
                self.handle(.failure(.mapError(error)), rawData: rawData, completion: completion)
                return
            }

            // Convert response to an HTTPURLResponse so we can get the status code
            guard let httpResponse = response as? HTTPURLResponse else {
                self.handle(.failure(.invalidResponse(response)), rawData: data, completion: completion)
                return
            }

            // Ensure we got back a status code lower than 400 - Success
            guard self.acceptableStatusCodes.contains(httpResponse.statusCode) else {
                self.handle(.failure(.invalidResponse(httpResponse)), rawData: data, completion: completion)
                return
            }

            do {
                let decodable = try JSONDecoder().decode(DataWrapper<T>.self, from: data)
                self.handle(.success(decodable.data), rawData: data, completion: completion)
            } catch {
                self.handle(.failure(.decodingError(error)), rawData: data, completion: completion)
            }
        }
    }

    func handle<T: Decodable>(_ result: RequestResult<T>, rawData: Data?, completion: @escaping RequestClosure<T>) {

        // Debug: Print JSON
        do {
            if let rawData = rawData { print(try rawData.prettyPrintedJson()) }
        } catch {}

        DispatchQueue.main.async {
            completion(result)
        }
    }
}

extension Data {

    func prettyPrintedJson() throws -> String {
        let jsonObject: Any
        let jsonData: Data

        do {
            jsonObject = try JSONSerialization.jsonObject(with: self)
        } catch {
            throw RequestError.decodingError(error)
        }

        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            throw RequestError.decodingError(error)
        }

        guard let string = String(data: jsonData, encoding: .utf8) else {
            let userInfo: [String: Any] = [NSLocalizedFailureReasonErrorKey: "Conversion to pretty printed string failed"]
            let error = NSError(domain: "", code: 0, userInfo: userInfo)
            throw RequestError.decodingError(error)
        }
        return string
    }
}
