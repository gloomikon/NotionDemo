import SwiftUI

struct HistoryView: View {

    let facts: [String]

    var body: some View {
        List(facts.indices, id: \.self) { idx in
            Text(facts[idx])
        }
        .onAppear {
            SimpleLogger.app.log("history_screen_shown")
        }
    }
}
