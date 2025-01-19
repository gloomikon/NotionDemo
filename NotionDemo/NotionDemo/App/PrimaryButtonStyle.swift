import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.purple.opacity(0.5), in: .capsule)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {

    static var primary: Self { Self() }
}
