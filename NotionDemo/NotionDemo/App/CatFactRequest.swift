private struct CatFactRequest: Request {

    var host: String {
        "https://catfact.ninja"
    }

    var path: String {
        "/fact"
    }

    var method: HTTPMethod {
        .get
    }

    var body: (any Encodable)? {
        nil
    }

    var headers: [String : String]? {
        ["Accept": "application/json"]
    }
}

private struct CatFactResponse: Decodable {
    let fact: String
}

extension NetworkManager {

    func catFact() async throws -> String {
        let response: CatFactResponse = try await request(CatFactRequest())
        return response.fact
    }
}
