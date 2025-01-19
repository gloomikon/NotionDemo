import SwiftUI

struct NetworkLogsListView: View {

    var body: some View {
        List(NetworkLogger.app.logs) { log in
            VStack(alignment: .leading) {
                Text(log.request.url!.absoluteString)

                if let json = log.data?.prettyJSON {
                    Text(json)
                        .lineLimit(8)
                        .font(.caption)
                }
            }
        }
    }
}
