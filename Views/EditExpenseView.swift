import SwiftUI
import SwiftData

struct EditExpenseView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var group: Group
    @Bindable var expense: Expense

    @State private var title = ""
    @State private var amount = ""
    @State private var paidBy: Member?
    @State private var selectedParticipantIDs = Set<PersistentIdentifier>()
    @State private var category = "Food"

    var body: some View {
        Form {
            Section("Expense") {
                TextField("Title", text: $title)

                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
            }
            
            Section("Category") {
                Picker("Category", selection: $category) {
                    ForEach(ExpenseCategory.all) { category in
                        Label(category.name, systemImage: category.icon)
                            .tag(category.name)
                    }
                }
            }

            Section("Paid By") {
                Picker("Paid By", selection: $paidBy) {
                    Text("Select").tag(Member?.none)

                    ForEach(group.members) { member in
                        Text(member.name).tag(Member?.some(member))
                    }
                }
            }

            Section("Split Between") {
                ForEach(group.members) { member in
                    Toggle(member.name, isOn: Binding(
                        get: {
                            selectedParticipantIDs.contains(member.persistentModelID)
                        },
                        set: { isSelected in
                            if isSelected {
                                selectedParticipantIDs.insert(member.persistentModelID)
                            } else {
                                selectedParticipantIDs.remove(member.persistentModelID)
                            }
                        }
                    ))
                }
            }
        }
        .navigationTitle("Edit Expense")
        .onAppear {
            title = expense.title
            category = expense.category
            amount = String(expense.amount)
            paidBy = expense.paidBy
            selectedParticipantIDs = Set(expense.participants.map { $0.persistentModelID })
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveChanges()
                }
                .disabled(!canSave)
            }
        }
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(amount) != nil &&
        paidBy != nil &&
        !selectedParticipantIDs.isEmpty
    }

    private func saveChanges() {
        guard let amountValue = Double(amount), let paidBy else { return }

        expense.title = title
        expense.amount = amountValue
        expense.category = category
        expense.paidBy = paidBy
        expense.participants = group.members.filter {
            selectedParticipantIDs.contains($0.persistentModelID)
        }

        dismiss()
        
        let activity = ActivityItem(
            title: "Edited expense",
            detail: "\(title) • \(amountValue.formatted(.currency(code: "USD")))",
            group: group
        )

        group.activities.append(activity)
    }
}
