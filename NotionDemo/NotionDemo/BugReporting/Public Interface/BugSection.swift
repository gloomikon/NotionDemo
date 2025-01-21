struct BugSection: BugInfo {

    private let title: String
    private let rows: [Row]

    init(
        _ title: String,
        @RowResultBuilder rows: () -> [Row]
    ) {
        self.title = title
        self.rows = rows()
    }

    var content: [RichTextObject] {
        CollectionOfOne(RichTextObject(text: title + "\n", annotations: .init(bold: true))) +
        rows.flatMap { row in
            [
                RichTextObject(text: row.title + ": ", annotations: .init(bold: true)),
                RichTextObject(text: row.description + "\n"),
            ]
        }
    }
}
