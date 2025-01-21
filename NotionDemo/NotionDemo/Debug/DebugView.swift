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
                Section("Logs") {
                    Button("📑 Simple logs") {
                        path.append(Path.simpleLogs)
                    }

                    Button("🌐 Network logs") {
                        path.append(Path.networkLogs)
                    }

                    Button("🐞 Create bug") {
                        createBug {
                            BugSection("General Info") {
                                Row(title: "Device", description: UIDevice.current.modelName)
                                Row(title: "iOS", description: UIDevice.current.systemVersion)
                                Row(title: "App version", description: Bundle.main.appVersion)
                                Row(title: "Build number", description: Bundle.main.buildVersion)
                            }

                            Comment(
                                "Analytics Logs",
                                logs: SimpleLogger.app.logs
                                    .map(\.text)
                                    .joined(separator: "\n***********\n")
                            )

                            Comment(
                                "Network Logs",
                                logs: NetworkLogger.app.logs
                                    .map(\.debugDescription)
                                    .joined(separator: "\n***********\n")
                            )
                        }
                    }
                }

                Section("Info") {
                    let device = UIDevice.current.modelName
                    Text("Device\n\(device)")

                    let iOS = UIDevice.current.systemVersion
                    Text("iOS\n\(iOS)")

                    let appVersion = Bundle.main.appVersion
                    Text("App version\n\(appVersion)")

                    let buildNumber = Bundle.main.buildVersion
                    Text("Build number\n\(buildNumber)")
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
