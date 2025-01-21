struct Comment: BugInfo {

    var content: [RichTextObject] {
        _content()
    }

    private let _content: () -> [RichTextObject]

    init(
        _ title: String,
        logs: @autoclosure @escaping () -> String
    ) {
        _content = {
            [
                RichTextObject(text: title + "\n", annotations: .init(bold: true))
            ] + logs().chunks(maxLength: 2000).map { string in
                RichTextObject(
                    text: string,
                    annotations: .init(code: true)
                )
            }
        }
    }
}

private extension String {

    func chunks(maxLength: Int) -> [String] {
        var result: [String] = []
        var currentIndex = startIndex

        while currentIndex < endIndex {
            let endIndex = index(currentIndex, offsetBy: maxLength, limitedBy: endIndex) ?? endIndex
            let substring = String(self[currentIndex..<endIndex])
            result.append(substring)
            currentIndex = endIndex
        }

        return result
    }
}

