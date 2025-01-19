import SwiftUI

@main
struct NotionDemoApp: App {

    @State private var didShake = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .sheet(isPresented: $didShake) {
                    DebugView()
                }
                .onShake { didShake = true }
        }
    }
}
