import SwiftUI

struct Priority: Identifiable {

    let id: String
    let name: String
    let color: String
    let backgroundColor: Color
}

extension Priority: Hashable, Equatable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Priority, rhs: Priority) -> Bool {
        lhs.id == rhs.id
    }
}

extension Priority: CaseIterable {

    static let low = Self(
        id: "dDuS",
        name: "Low",
        color: "blue",
        backgroundColor: .blue.opacity(0.5)
    )

    static let medium = Self(
        id: "V;iD",
        name: "Medium",
        color: "yellow",
        backgroundColor: .yellow.opacity(0.5)
    )

    static let high = Self(
        id: "Jhp=",
        name: "High",
        color: "red",
        backgroundColor: .red.opacity(0.5)
    )

    static let blocker = Self(
        id: "aD><",
        name: "Blocker",
        color: "pink",
        backgroundColor: .pink.opacity(0.5)
    )

    static var allCases: [Self] {
        [
            .low,
            .medium,
            .high,
            .blocker
        ]
    }
}
