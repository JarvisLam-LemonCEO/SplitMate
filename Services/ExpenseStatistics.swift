import Foundation

struct CategoryStat: Identifiable {
    let id = UUID()
    let category: String
    let total: Double
}

struct ExpenseStatistics {

    static func categoryTotals(for group: Group) -> [CategoryStat] {

        var totals: [String: Double] = [:]

        for expense in group.expenses {
            totals[expense.category, default: 0] += expense.amount
        }

        return totals
            .map {
                CategoryStat(
                    category: $0.key,
                    total: $0.value
                )
            }
            .sorted {
                $0.total > $1.total
            }
    }

}
