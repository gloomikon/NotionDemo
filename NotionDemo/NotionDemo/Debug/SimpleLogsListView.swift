import SwiftUI

struct SimpleLogsListView: View {

    var body: some View {
        List(SimpleLogger.app.logs) { log in
            Text(log.text)
        }
    }
}
