struct RichTextObject: Encodable {
    let type: String = "text"
    let text: TextObject
    let annotations: AnnotationsObject
    let plantText: String
    let href: String?

    enum CodingKeys: String, CodingKey {
        case type
        case text
        case annotations
        case plantText = "plain_text"
        case href
    }
}

extension RichTextObject {

    init(text: String) {
        self.text = TextObject(content: text, link: nil)
        self.annotations = AnnotationsObject(
            bold: false,
            italic: false,
            strikethrough: false,
            underline: false,
            code: false
        )
        self.plantText = text
        self.href = nil
    }

    init(text: String, annotations: AnnotationsObject) {
        self.text = TextObject(content: text, link: nil)
        self.annotations = annotations
        self.plantText = text
        self.href = nil
    }
}

extension RichTextObject {

    struct TextObject: Encodable {
        let content: String
        let link: String?
    }

    struct AnnotationsObject: Encodable {
        var bold = false
        var italic = false
        var strikethrough = false
        var underline = false
        var code = false
        var color = "default"
    }
}

@resultBuilder enum RichTextObjectBuilder {

    static func buildPartialBlock(first: RichTextObject) -> [RichTextObject] {
        [first]
    }

    static func buildPartialBlock(first: [RichTextObject]) -> [RichTextObject] {
        first
    }

    static func buildPartialBlock(accumulated: [RichTextObject], next: RichTextObject) -> [RichTextObject] {
        accumulated + CollectionOfOne(next)
    }

    static func buildPartialBlock(accumulated: [RichTextObject], next: [RichTextObject]) -> [RichTextObject] {
        accumulated + next
    }

    static func buildOptional(_ component: [RichTextObject]?) -> [RichTextObject] {
        if let component {
            component
        } else {
            []
        }
    }
}

extension [RichTextObject] {
    static var divider: Self {
        [
            RichTextObject(text: "\n"),
            RichTextObject(
                text: "———————————————————————————————————————————————",
                annotations: RichTextObject.AnnotationsObject(code: true, color: "gray")
            ),
            RichTextObject(text: "\n"),
            RichTextObject(text: "\n"),
        ]
    }
}
