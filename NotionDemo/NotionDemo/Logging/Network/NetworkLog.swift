import Foundation

struct NetworkLog: Identifiable {

    let id: UUID
    let requestDate: Date
    let request: URLRequest

    var data: Data?
    var response: URLResponse? {
        didSet {
            responseDate = .now
        }
    }
    var error: String? {
        didSet {
            responseDate = .now
        }
    }
    var responseDate: Date?

    init(id: UUID, request: URLRequest) {
        self.id = id
        self.requestDate = .now
        self.request = request
    }

    var requestMethod: String {
        request.httpMethod!
    }

    var requestURL: String {
        request.url!.absoluteString
    }

    var requestHeaders: [String: String]? {
        request.allHTTPHeaderFields
    }

    var httpBody: Data? {
        request.httpBody
    }

    var responseStatusCode: Int? {
        (response as? HTTPURLResponse)?.statusCode
    }

    var responseHeaders: [String: String]? {
        (response as? HTTPURLResponse)?.allHeaderFields.reduce(into: [:]) {
            let key = "\($1.key)"
            let value = "\($1.value)"
            $0[key] = value
        }
    }

    var duration: Int? {
        responseDate.map { responseDate in
            Int(responseDate.timeIntervalSince(requestDate))
        }
    }

    var debugDescription: String {
        var string =
        """
        \(requestDate.formatted(date: .complete, time: .standard))
        [\(requestMethod)] \(requestURL)
        """

        if let requestHeaders {
            let headers =
            """
            {
            \(requestHeaders.map { key, value in "    \(key) : \(value)"}.joined(separator: "\n"))
            }
            """

            string += "\n\nRequest Headers:\n\(headers)"
        }

        if let httpBody {
            let body = httpBody.prettyJSON ?? "data is not json"

            string += "\n\nRequest Body:\n\(body)"
        }

        if let statusCode = responseStatusCode {
            string += "\n\nResponse status code:\n\(statusCode)"
        }

        if let responseHeaders {
            let headers =
            """
            {
            \(responseHeaders.map { key, value in "    \(key) : \(value)"}.joined(separator: "\n"))
            }
            """

            string += "\n\nResponse Headers:\n\(headers)"
        }

        if let httpBody = data {
            let body = httpBody.prettyJSON ?? "data is not json"

            string += "\n\nResponse Body:\n\(body)"
        }

        if let error {
            string += "\n\nError: \(error)"
        }

        return string
    }
}
