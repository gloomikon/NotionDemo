import SwiftUI

struct BugReportingView: View {

    @ObservedObject var viewModel: BugReportingViewModel

    @State var path = NavigationPath()

    @ViewBuilder
    private func textField(_ title: String, text: Binding<String>) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
        TextField("", text: text, axis: .vertical)
    }

    private func picker() -> some View {
        Menu {
            Picker("", selection: $viewModel.priority) {
                ForEach(Priority.allCases) { priority in
                    Text(priority.name)
                        .tag(priority)
                }
            }
            .labelsHidden()
        } label: {
            HStack {
                Text("Priority")
                    .font(.system(size: 18, weight: .semibold))

                Spacer()

                HStack {

                    Text(viewModel.priority.name)

                    Image(systemName: "arrowtriangle.down.circle")
                        .resizable()
                        .frame(width: 18, height: 18)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 6)
                .background(viewModel.priority.backgroundColor, in: .rect(cornerRadius: 4))
            }
            .foregroundStyle(Color(.label))
        }
    }

    var body: some View {
        NavigationStack(path: $path) { // yes, it is needed
            ScrollView {
                VStack(alignment: .leading) {
                    textField("Issue title", text: $viewModel.issueTitle)
                    Divider()
                    picker()
                    Divider()
                    textField("Preconditions", text: $viewModel.preconditions)
                    Divider()
                    textField("Steps to reproduce", text: $viewModel.str)
                    Divider()
                    textField("Expected result", text: $viewModel.expectedResult)
                    Divider()
                    textField("Actual result", text: $viewModel.actualResult)
                }
                .padding()
                .textFieldStyle(DefaultTextFieldStyle())
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button {
                        dismissKeyboard()
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    dismissKeyboard()
                    viewModel.createPage()
                } label: {
                    Text("Create")
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue.brightness(-0.2))
                        .clipShape(.capsule)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .background(.background)
            }
            .navigationTitle("Bug Reporting")
            .overlay {
                if viewModel.isLoading {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .overlay {
                            ProgressView()
                                .scaleEffect(1.5)
                        }
                }
            }
            .alert(item: $viewModel.alert) { alert in
                switch alert {
                case let .error(error):
                    Alert(
                        title: Text("Error"),
                        message: Text(error),
                        dismissButton: .default(Text("OK"))
                    )
                case let .success(urlString):
                    Alert(
                        title: Text("Success"),
                        message: Text("Ticket was created"),
                        primaryButton: .default(Text("Done")) {
                            viewModel.clear()
                        },
                        secondaryButton: .default(Text("Open")) {
                            viewModel.clear()
                            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                }
            }
        }
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
