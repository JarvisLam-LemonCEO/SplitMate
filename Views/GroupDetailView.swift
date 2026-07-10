import SwiftUI
import SwiftData

struct GroupDetailView: View {
    @Bindable var group: Group

    @State private var showingAddMember = false
    @State private var showingAddExpense = false

    private var totalSpent: Double {
        group.expenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Group Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(totalSpent, format: .currency(code: "USD"))
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack {
                        Label("\(group.members.count) members", systemImage: "person.2.fill")
                        Spacer()
                        Label("\(group.expenses.count) expenses", systemImage: "creditcard.fill")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            Section("Members") {
                ForEach(group.members) { member in
                    Label(member.name, systemImage: "person.fill")
                }
                .onDelete(perform: deleteMembers)

                Button {
                    showingAddMember = true
                } label: {
                    Label("Add Member", systemImage: "plus.circle.fill")
                }
            }

            Section("Expenses") {
                if group.expenses.isEmpty {
                    ContentUnavailableView(
                        "No Expenses",
                        systemImage: "creditcard",
                        description: Text("Tap Add Expense to record your first shared cost.")
                    )
                } else {
                    ForEach(group.expenses) { expense in
                        NavigationLink {
                            EditExpenseView(group: group, expense: expense)
                        } label: {
                            ExpenseRowView(expense: expense)
                        }
                    }
                    .onDelete(perform: deleteExpenses)
                }

                Button {
                    showingAddExpense = true
                } label: {
                    Label("Add Expense", systemImage: "plus.circle.fill")
                }
            }

            Section {
                NavigationLink("View Balances") {
                    BalanceView(group: group)
                }
            }
        }
        .navigationTitle(group.name)
        .sheet(isPresented: $showingAddMember) {
            AddMemberView(group: group)
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(group: group)
        }
    }

    private func deleteExpenses(at offsets: IndexSet) {
        for index in offsets {
            group.expenses.remove(at: index)
        }
    }
    
    private func deleteMembers(at offsets: IndexSet) {
        for index in offsets {
            let member = group.members[index]

            for expense in group.expenses {
                expense.participants.removeAll {
                    $0.persistentModelID == member.persistentModelID
                }

                if expense.paidBy?.persistentModelID == member.persistentModelID {
                    expense.paidBy = nil
                }
            }

            group.members.remove(at: index)
        }
    }
}
