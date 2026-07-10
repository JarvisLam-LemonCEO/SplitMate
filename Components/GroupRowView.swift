import SwiftUI

struct GroupRowView: View {
    let group: Group

    private var totalSpent: Double {
        group.expenses.reduce(0) { $0 + $1.amount }
    }

    private var memberPreview: [Member] {
        Array(group.members.prefix(3))
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
                Text("Total Spent")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(totalSpent, format: .currency(code: "USD"))
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
