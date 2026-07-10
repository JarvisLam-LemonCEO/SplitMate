import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var group: Group

    @State private var title = ""
    @State private var amount = ""
    @State private var paidByID: PersistentIdentifier?
    @State private var selectedParticipantIDs = Set<PersistentIdentifier>()
    @State private var category = "Food"

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense") {
                    TextField("Example: Pizza", text: $title)

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
                    Picker("Paid By", selection: $paidByID) {
                        Text("Select").tag(PersistentIdentifier?.none)

                        ForEach(group.members) { member in
                            Text(member.name)
                                .tag(PersistentIdentifier?.some(member.persistentModelID))
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
            .navigationTitle("Add Expense")
            .onAppear {
                if paidByID == nil {
                    paidByID = group.members.first?.persistentModelID
                }

                selectedParticipantIDs = Set(group.members.map { $0.persistentModelID })
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExpense()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(amount) != nil &&
        paidByID != nil &&
        !selectedParticipantIDs.isEmpty
    }

    private func saveExpense() {
        guard
            let amountValue = Double(amount),
            let paidByID,
            let paidBy = group.members.first(where: { $0.persistentModelID == paidByID })
        else { return }

        let selectedParticipants = group.members.filter {
            selectedParticipantIDs.contains($0.persistentModelID)
        }

        let expense = Expense(
            title: title.trimmingCharacters(in: .whitespaces),
            amount: amountValue,
            paidBy: paidBy,
            group: group,
            participants: selectedParticipants,
            category: category
        )

        group.expenses.append(expense)
        
        Haptics.success()
       
        let activity = ActivityItem(
            title: "Added expense",
            detail: "\(title) • \(amountValue.formatted(.currency(code: "USD")))",
            group: group
        )

        group.activities.append(activity)

        dismiss()
    }
}
