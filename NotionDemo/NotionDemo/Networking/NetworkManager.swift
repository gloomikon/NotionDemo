import Foundation

struct NetworkError: Error {
    let description: String

    init(_ description: String) {
        self.description = description
    }
}

class NetworkManager {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<R: Request, T: Decodable>(_ request: R) async throws -> T {
        let id = UUID()
        let request = try makeRequest(for: request)

        if !request.url!.absoluteString.contains("notion") {
            NetworkLogger.app.log(request, withID: id)
        }

        let responseData: Data

        do {
            let (data, response) = try await session.data(for: request)
            NetworkLogger.app.log(response, data: data, withID: id)
            responseData = data
        } catch {
            NetworkLogger.app.log(error.localizedDescription, withID: id)
            throw error
        }

        return try JSONDecoder().decode(T.self, from: responseData)
    }

    private func makeRequest(for request: Request) throws -> URLRequest {
        guard
            let path = request.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            var components = URLComponents(string: request.host + path) else {
            throw NetworkError("Invalid URL \(request.host)\(request.path)")
        }

        components.queryItems = request.queryItems

        guard let url = components.url else {
            throw NetworkError("Invalid URL \(request.host)\(request.path)")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body.flatMap { body in
            if let body = body as? Data {
                body
            } else {
                try? JSONEncoder().encode(body)
            }
        }
        urlRequest.httpMethod = request.method.rawValue

        return urlRequest
    }
}
