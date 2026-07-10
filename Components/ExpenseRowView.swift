import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: ExpenseCategory.icon(for: expense.category))
                .font(.title2)
                .frame(width: 36, height: 36)
                .background(Color.blue.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.headline)

                HStack(spacing: 4) {
                    Text(expense.category)
                    Text("•")
                    Text("Paid by \(expense.paidBy?.name ?? "Unknown")")
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                if let subtotal = expense.subtotal,
                   let tax = expense.tax,
                   let tipPercentage = expense.tipPercentage {
                    Text(
                        "Subtotal \(subtotal.formatted(.currency(code: "USD"))) • Tax \(tax.formatted(.currency(code: "USD"))) • Tip \(Int(tipPercentage))%"
                    )
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Text(expense.amount, format: .currency(code: "USD"))
                .font(.headline)
            
            if expense.receiptImageData != nil {
                Image(systemName: "paperclip")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
