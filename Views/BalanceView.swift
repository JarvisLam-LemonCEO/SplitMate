import SwiftUI

struct BalanceView: View {
    let group: Group

    private var settlements: [Settlement] {
        BalanceCalculator.settlements(for: group)
    }

    var body: some View {
        List {
            Section("Who Owes Whom") {
                if settlements.isEmpty {
                    ContentUnavailableView(
                        "All Settled",
                        systemImage: "checkmark.circle",
                        description: Text("Nobody owes anything right now.")
                    )
                } else {
                    ForEach(settlements) { settlement in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(settlement.from.name) → \(settlement.to.name)")
                                    .font(.headline)

                                Text("Payment")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(settlement.amount, format: .currency(code: "USD"))
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
        .navigationTitle("Settle Up")
    }
}
