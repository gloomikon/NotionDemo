import Foundation

struct SimpleLog: Identifiable {

    let id = UUID()
    let text: String
    let date = Date()

    init(_ text: String) {
        self.text = text
    }
}
