import SwiftUI

private enum Path {

    case simpleLogs
    case networkLogs
}

extension Path: Hashable {

    static func == (lhs: Path, rhs: Path) -> Bool {
        switch (lhs, rhs) {
        case (.simpleLogs, .simpleLogs),
            (.networkLogs, networkLogs):
            true
        default:
            false
        }
    }

    private var id: String {
        String(reflecting: self)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct DebugView: View {

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Button("📑 Simple logs") {
                    path.append(Path.simpleLogs)
                }

                Button("🌐 Network logs") {
                    path.append(Path.networkLogs)
                }
            }
            .navigationDestination(for: Path.self) { path in
                switch path {
                case .simpleLogs:
                    SimpleLogsListView()
                case .networkLogs:
                    NetworkLogsListView()
                }
            }
        }
    }
}
