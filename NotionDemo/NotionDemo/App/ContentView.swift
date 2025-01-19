import SwiftUI

private enum Path: Hashable {
    case historyOfFacts([String])
}

struct ContentView: View {

    @State private var catFact: String?
    @State private var historyOfFacts: [String] = []
    @State private var isLoading = false

    private let networkManager = NetworkManager()

    private var currentFactText: some View {
        Text(catFact ?? "Press button to get a fact")
            .font(.system(size: 18, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentTransition(.numericText())
            .frame(maxHeight: .infinity)
    }

    private var getFactButton: some View {
        Button("Get fact") {
            SimpleLogger.app.log("get_fact_button_tapped")
            if isLoading { return }
            Task {
                await setLoading(true)
                do {
                    let fact = try await networkManager.catFact()
                    historyOfFacts.append(fact)
                    withAnimation {
                        catFact = fact
                    }
                } catch {
                }
                await setLoading(false)
            }
        }
        .buttonStyle(.primary)
    }

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                currentFactText
                getFactButton
            }
            .padding()
            .toolbar {
                ToolbarItem {
                    Button("History") {
                        SimpleLogger.app.log("history_button_tapped")
                        path.append(Path.historyOfFacts(historyOfFacts))
                    }
                }
            }
            .navigationDestination(for: Path.self) { path in
                switch path {
                case let .historyOfFacts(facts):
                    HistoryView(facts: facts)
                }
            }
            .navigationTitle("🐱 Cat fact")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            SimpleLogger.app.log("main_screen_shown")
        }
    }


    @MainActor
    private func setLoading(_ loading: Bool) async {
        isLoading = loading
    }
}
