protocol BugInfo {
    var content: [RichTextObject] { get }
}

@resultBuilder
enum BugInfoResultBuilder {

    static func buildBlock(_ components: BugInfo...) -> [BugInfo] {
        components
    }
}
