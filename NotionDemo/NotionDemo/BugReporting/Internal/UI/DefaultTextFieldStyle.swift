import SwiftUI

struct DefaultTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration.body
            .padding(8)
            .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 8))

    }
}
