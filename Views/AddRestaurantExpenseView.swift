import SwiftUI
import SwiftData

struct AddRestaurantExpenseView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var group: Group

    @State private var restaurantName = ""
    @State private var subtotal = ""
    @State private var tax = ""
    @State private var tipPercentage = 18.0
    @State private var paidByID: PersistentIdentifier?
    @State private var selectedParticipantIDs = Set<PersistentIdentifier>()

    private let tipOptions = [15.0, 18.0, 20.0, 22.0]

    private var subtotalValue: Double {
        Double(subtotal) ?? 0
    }

    private var taxValue: Double {
        Double(tax) ?? 0
    }

    private var total: Double {
        RestaurantSplitCalculator.total(
            subtotal: subtotalValue,
            tax: taxValue,
            tipPercentage: tipPercentage
        )
    }

    private var perPerson: Double {
        RestaurantSplitCalculator.perPerson(
            total: total,
            peopleCount: selectedParticipantIDs.count
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Restaurant") {
                    TextField("Example: Gen Korean BBQ", text: $restaurantName)

                    TextField("Subtotal", text: $subtotal)
                        .keyboardType(.decimalPad)

                    TextField("Tax", text: $tax)
                        .keyboardType(.decimalPad)
                }

                Section("Tip") {
                    Picker("Tip", selection: $tipPercentage) {
                        ForEach(tipOptions, id: \.self) { tip in
                            Text("\(Int(tip))%").tag(tip)
                        }
                    }
                    .pickerStyle(.segmented)

                    Stepper("Custom Tip: \(Int(tipPercentage))%", value: $tipPercentage, in: 0...50, step: 1)
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

                Section("Summary") {
                    HStack {
                        Text("Tip")
                        Spacer()
                        Text(RestaurantSplitCalculator.tipAmount(
                            subtotal: subtotalValue,
                            tipPercentage: tipPercentage
                        ), format: .currency(code: "USD"))
                    }

                    HStack {
                        Text("Total")
                        Spacer()
                        Text(total, format: .currency(code: "USD"))
                            .fontWeight(.bold)
                    }

                    HStack {
                        Text("Per Person")
                        Spacer()
                        Text(perPerson, format: .currency(code: "USD"))
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("Restaurant Split")
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
                        saveRestaurantExpense()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        !restaurantName.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(subtotal) != nil &&
        Double(tax) != nil &&
        paidByID != nil &&
        !selectedParticipantIDs.isEmpty
    }

    private func saveRestaurantExpense() {
        guard
            let subtotalValue = Double(subtotal),
            let taxValue = Double(tax),
            let paidByID,
            let paidBy = group.members.first(where: { $0.persistentModelID == paidByID })
        else { return }

        let selectedParticipants = group.members.filter {
            selectedParticipantIDs.contains($0.persistentModelID)
        }

        let totalAmount = RestaurantSplitCalculator.total(
            subtotal: subtotalValue,
            tax: taxValue,
            tipPercentage: tipPercentage
        )

        let expense = Expense(
            title: restaurantName.trimmingCharacters(in: .whitespaces),
            amount: totalAmount,
            paidBy: paidBy,
            group: group,
            participants: selectedParticipants,
            category: "Food",
            subtotal: subtotalValue,
            tax: taxValue,
            tipPercentage: tipPercentage,
            splitMethod: "Equal"
        )

        group.expenses.append(expense)

        let activity = ActivityItem(
            title: "Added restaurant split",
            detail: "\(expense.title) • \(totalAmount.formatted(.currency(code: "USD")))",
            group: group
        )

        group.activities.append(activity)

        Haptics.success()
        dismiss()
    }
}
