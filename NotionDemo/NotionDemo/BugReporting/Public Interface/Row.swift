struct Row {
    let title: String
    let description: String
}

@resultBuilder
enum RowResultBuilder {

    static func buildBlock(_ components: Row...) -> [Row] {
        components
    }
}
