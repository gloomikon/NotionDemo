private struct CreatePageRequest: Request {

    var host: String { "https://api.notion.com/v1/" }

    var path: String { "pages" }

    var method: HTTPMethod { .post }

    var headers: [String : String]? {
        [
            "Authorization": "Bearer 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",
            "Content-Type": "application/json",
            "Notion-Version": "2022-06-28"
        ]
    }

    let body: (any Encodable)?

    init(
        name: String,
        priority: Priority,
        description: [RichTextObject]
    ) {
        self.body = CreatePageBody(
            name: name,
            description: description,
            priority: priority
        )
    }
}

struct CreatePageResponse: Decodable {
    let id: String
    let url: String
}

extension NetworkManager {

    func createPage(
        name: String,
        priority: Priority,
        @RichTextObjectBuilder description: () -> [RichTextObject]
    ) async throws -> CreatePageResponse {
        try await request(
            CreatePageRequest(
                name: name,
                priority: priority,
                description: description()
            )
        )
    }
}
