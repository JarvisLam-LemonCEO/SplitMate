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

    private var allBalances: [Balance] {
        BalanceCalculator.balances(for: group)
    }

    private var balanceText: String {
        if group.expenses.isEmpty {
            return "No expenses yet"
        }

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

    private var balanceBadgeColor: Color {
        if group.expenses.isEmpty {
            return .gray
        }

        if allBalances.isEmpty {
            return .blue
        }

        guard let userBalance else {
            return .orange
        }

        if userBalance > 0.01 {
            return .green
        } else if userBalance < -0.01 {
            return .red
        } else {
            return .blue
        }
    }

    private var balanceIcon: String {
        if group.expenses.isEmpty {
            return "creditcard"
        }

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
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                Image(systemName: group.icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 48, height: 48)
                    .background(Color.blue.opacity(0.12))
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

            Label(balanceText, systemImage: balanceIcon)
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(balanceBadgeColor.opacity(0.12))
                .foregroundColor(balanceBadgeColor)
                .clipShape(Capsule())

            Divider()

            HStack {
                Text("Total Spent")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(totalSpent, format: .currency(code: currencyCode))
                    .font(.headline)
            }

            if !memberPreview.isEmpty {
                HStack(spacing: -12) {
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
                            .overlay(
                                Circle()
                                    .stroke(Color(.systemBackground), lineWidth: 2)
                            )
                    }

                    Spacer()
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(.separator).opacity(0.35), lineWidth: 1)
        )
    }
}
