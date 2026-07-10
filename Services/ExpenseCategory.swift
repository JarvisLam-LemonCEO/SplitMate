import Foundation

struct ExpenseCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String

    static let all: [ExpenseCategory] = [
        ExpenseCategory(name: "Food", icon: "fork.knife"),
        ExpenseCategory(name: "Transport", icon: "car.fill"),
        ExpenseCategory(name: "Hotel", icon: "bed.double.fill"),
        ExpenseCategory(name: "Shopping", icon: "bag.fill"),
        ExpenseCategory(name: "Entertainment", icon: "party.popper.fill"),
        ExpenseCategory(name: "Other", icon: "ellipsis.circle.fill")
    ]

    static func icon(for name: String) -> String {
        all.first { $0.name == name }?.icon ?? "creditcard.fill"
    }
}
