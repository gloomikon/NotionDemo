import Combine

enum AlertType: Identifiable {

    case error(String)
    case success(String)

    var id: String {
        String(reflecting: self)
    }
}

class BugReportingViewModel: ObservableObject {

    private let networkManager = NetworkManager()

    @Published var issueTitle = ""
    @Published var priority = Priority.low
    @Published var preconditions = ""
    @Published var str = ""
    @Published var actualResult = ""
    @Published var expectedResult = ""

    @Published var alert: AlertType?
    @Published private(set) var isLoading = false

    private let infos: [BugInfo]

    init(infos: [BugInfo]) {
        self.infos = infos
    }

    private var additionalDescriptionInfo: [RichTextObject] {
        infos
            .compactMap { info in
                info as? BugSection
            }.map { section in
                section.content + [RichTextObject].divider
            }
            .flatMap { $0 }
    }

    private var comments: [[RichTextObject]] {
        infos.compactMap { $0 as? Comment }.map(\.content)
    }

    func createPage() {
        isLoading = true
        Task {
            if issueTitle.isEmpty {
                await changeAlert(to: .error("Title can not be empty"))
                return
            }
            do {
                let page = try await tryCreatePage()

                for comment in comments {
                    try await writeComment(pageID: page.id, richText: comment)
                }
                await changeAlert(to: .success(page.url))
            } catch {
                await changeAlert(to: .error("Something went wrong"))
            }
        }
    }

    @discardableResult
    private func writeComment(pageID: String, richText: [RichTextObject]) async throws -> WriteCommentResponse {
        try await networkManager.writeComment(
            pageID: pageID,
            richText: richText
        )
    }

    private func tryCreatePage() async throws -> CreatePageResponse {
        try await networkManager.createPage(
            name: issueTitle,
            priority: priority
        ) {
            additionalDescriptionInfo

            if !preconditions.isEmpty {
                RichTextObject(text: "🤔 Preconditions:\n", annotations: .init(bold: true))
                preconditions.split(separator: "\n")
                    .map {
                        String($0)
                    }
                    .enumerated()
                    .map { idx, string in
                        RichTextObject(text: "\(idx + 1). \(string)\n")
                    }

                [RichTextObject].divider
            }

            if !str.isEmpty {
                RichTextObject(text: "🕵️‍♂️ Steps to reproduce:\n", annotations: .init(bold: true))
                str.split(separator: "\n")
                    .map {
                        String($0)
                    }
                    .enumerated()
                    .map { idx, string in
                        RichTextObject(text: "\(idx + 1). \(string)\n")
                    }

                [RichTextObject].divider
            }

            if !expectedResult.isEmpty {
                RichTextObject(text: "😍 Expected result:\n", annotations: .init(bold: true))
                RichTextObject(text: expectedResult + "\n")
                [RichTextObject].divider
            }

            if !actualResult.isEmpty {
                RichTextObject(text: "😢 Actual result:\n", annotations: .init(bold: true))
                RichTextObject(text: actualResult + "\n")
                [RichTextObject].divider
            }
        }
    }

    @MainActor
    private func changeAlert(to alert: AlertType) async {
        isLoading = false
        self.alert = alert
    }

    func clear() {
        issueTitle = ""
        preconditions = ""
        str = ""
        actualResult = ""
        expectedResult = ""
    }
}
