import SwiftUI
import SwiftData

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
                    ForEach(Array(settlements.enumerated()), id: \.offset) { _, settlement in
                        let paid = isPaid(settlement)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(settlement.from.name) → \(settlement.to.name)")
                                        .font(.headline)

                                    Text(paid ? "Marked as paid" : "Payment")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text(settlement.amount, format: .currency(code: "USD"))
                                    .foregroundColor(paid ? .secondary : .green)
                            }

                            Button {
                                markAsPaid(settlement)
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: paid ? "checkmark.circle.fill" : "circle")
                                    Text(paid ? "Paid" : "Mark as Paid")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .disabled(paid)
                            .opacity(paid ? 0.45 : 1.0)
                        }
                        .padding(.vertical, 6)
                        .opacity(paid ? 0.55 : 1.0)
                    }
                }
            }

            Section("Payment History") {
                if group.payments.isEmpty {
                    Text("No payments yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(group.payments.sorted { $0.date > $1.date }) { payment in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(payment.fromName) paid \(payment.toName)")
                                .font(.headline)

                            Text(payment.amount, format: .currency(code: "USD"))
                                .foregroundColor(.green)

                            Text(payment.date, style: .relative)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deletePayments)
                }
            }
        }
        .navigationTitle("Settle Up")
    }

    private func isPaid(_ settlement: Settlement) -> Bool {
        group.payments.contains { payment in
            payment.fromName == settlement.from.name &&
            payment.toName == settlement.to.name &&
            abs(payment.amount - settlement.amount) < 0.01
        }
    }

    private func markAsPaid(_ settlement: Settlement) {
        guard !isPaid(settlement) else { return }

        let payment = Payment(
            fromName: settlement.from.name,
            toName: settlement.to.name,
            amount: settlement.amount,
            group: group
        )

        group.payments.append(payment)
    }

    private func deletePayments(at offsets: IndexSet) {
        let sortedPayments = group.payments.sorted { $0.date > $1.date }

        for index in offsets {
            let payment = sortedPayments[index]

            if let originalIndex = group.payments.firstIndex(where: {
                $0.persistentModelID == payment.persistentModelID
            }) {
                group.payments.remove(at: originalIndex)
            }
        }
    }
}
