struct WriteCommentRequest: Request {

    var host: String { "https://api.notion.com/v1/" }

    var path: String { "comments" }

    var method: HTTPMethod { .post }

    var headers: [String : String]? {
        [
            "Authorization": "Bearer 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",
            "Content-Type": "application/json",
            "Notion-Version": "2022-06-28"
        ]
    }

    let body: (any Encodable)?

    init(pageID: String, richText: [RichTextObject]) {
        self.body = WriteCommentBody(pageID: pageID, richText: richText)
    }
}

struct WriteCommentResponse: Decodable {
    let id: String
}

extension NetworkManager {

    func writeComment(pageID: String, richText: [RichTextObject]) async throws -> WriteCommentResponse {
        try await request(WriteCommentRequest(pageID: pageID, richText: richText))
    }
}
