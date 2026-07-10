import SwiftUI
import SwiftData

struct GroupRowView: View {
    let group: Group
    let userName: String
    let currencyCode: String

    private var totalSpent: Double {
        group.expenses.reduce(0) { $0 + $1.amount }
    }

    private var memberPreview: [Member] {
        Array(group.members.prefix(3))
    }

    private var userBalance: Double? {
        BalanceCalculator.balances(for: group)
            .first { $0.member.name.lowercased() == userName.lowercased() }?
            .amount
    }

    private var balanceText: String {
        if group.expenses.isEmpty {
            return "No expenses yet"
        }

        let allBalances = BalanceCalculator.balances(for: group)

        if allBalances.isEmpty {
            return "Settled"
        }

        guard let userBalance else {
            return "Add yourself as a member"
        }

        if userBalance > 0.01 {
            return "You are owed \(userBalance.formatted(.currency(code: currencyCode)))"
        } else if userBalance < -0.01 {
            return "You owe \(abs(userBalance).formatted(.currency(code: currencyCode)))"
        } else {
            return "Settled"
        }
    }

    private var balanceIcon: String {
        if group.expenses.isEmpty {
            return "creditcard"
        }

        let allBalances = BalanceCalculator.balances(for: group)

        if allBalances.isEmpty {
            return "checkmark.circle.fill"
        }

        guard let userBalance else {
            return "person.crop.circle.badge.exclamationmark"
        }

        if userBalance > 0.01 {
            return "arrow.down.circle.fill"
        } else if userBalance < -0.01 {
            return "arrow.up.circle.fill"
        } else {
            return "checkmark.circle.fill"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: group.icon)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Color.blue.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 4) {
                    Text(group.name)
                        .font(.headline)

                    Text("\(group.members.count) members • \(group.expenses.count) expenses")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            HStack {
                Label(balanceText, systemImage: balanceIcon)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()
            }

            HStack {
                Text("Total Spent")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(totalSpent, format: .currency(code: currencyCode))
                    .font(.headline)
            }

            if !memberPreview.isEmpty {
                HStack(spacing: -8) {
                    ForEach(memberPreview) { member in
                        InitialAvatarView(name: member.name)
                            .overlay(
                                Circle()
                                    .stroke(Color(.systemBackground), lineWidth: 2)
                            )
                    }

                    if group.members.count > 3 {
                        Text("+\(group.members.count - 3)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(width: 36, height: 36)
                            .background(Color(.tertiarySystemBackground))
                            .clipShape(Circle())
                    }

                    Spacer()
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}
