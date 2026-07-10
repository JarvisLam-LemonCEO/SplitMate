import Foundation

struct GroupStats {
    let totalSpent: Double
    let expenseCount: Int
    let memberCount: Int
    let youPaid: Double
    let youOwe: Double
    let youAreOwed: Double
}

struct GroupStatsCalculator {
    static func stats(for group: Group, userName: String) -> GroupStats {
        let totalSpent = group.expenses.reduce(0) { $0 + $1.amount }

        let youPaid = group.expenses.reduce(0) { total, expense in
            if expense.paidBy?.name.lowercased() == userName.lowercased() {
                return total + expense.amount
            }
            return total
        }

        let balances = BalanceCalculator.balances(for: group)

        let yourBalance = balances.first {
            $0.member.name.lowercased() == userName.lowercased()
        }?.amount ?? 0

        return GroupStats(
            totalSpent: totalSpent,
            expenseCount: group.expenses.count,
            memberCount: group.members.count,
            youPaid: youPaid,
            youOwe: yourBalance < 0 ? abs(yourBalance) : 0,
            youAreOwed: yourBalance > 0 ? yourBalance : 0
        )
    }
}
