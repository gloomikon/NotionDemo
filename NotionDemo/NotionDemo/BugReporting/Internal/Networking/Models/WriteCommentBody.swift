struct WriteCommentBody: Encodable {

    let parent: Parent
    let richText: [RichTextObject]

    init(pageID: String, richText: [RichTextObject]) {
        self.parent = Parent(pageID: pageID)
        self.richText = richText
    }

    enum CodingKeys: String, CodingKey {
        case parent
        case richText = "rich_text"
    }
}

extension WriteCommentBody {

    struct Parent: Encodable {
        let pageID: String

        enum CodingKeys: String, CodingKey {
            case pageID = "page_id"
        }
    }
}
