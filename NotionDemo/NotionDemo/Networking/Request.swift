import Foundation

protocol Request {

    var host: String { get }

    var path: String { get }

    var method: HTTPMethod { get }

    var body: Encodable? { get }

    var queryItems: [URLQueryItem]? { get }

    var headers: [String: String]? { get }
}

extension Request {

    var queryItems: [URLQueryItem]? {
        nil
    }

    var headers: [String: String]? {
        nil
    }
}
