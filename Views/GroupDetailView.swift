import SwiftUI
import SwiftData

struct GroupDetailView: View {
    @Bindable var group: Group
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddMember = false
    @State private var showingAddExpense = false
    @State private var searchText = ""
    @State private var showingRestaurantSplit = false
    @State private var shareURL: URL?

    private var totalSpent: Double {
        group.expenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        List {

            Section {

                DashboardCardView(
                    title: "Total Spent",
                    value: stats.totalSpent.formatted(.currency(code: settings.currencyCode)),
                    icon: "dollarsign.circle.fill"
                )

                HStack(spacing: 12) {
                    DashboardCardView(
                        title: "You Paid",
                        value: stats.youPaid.formatted(.currency(code: settings.currencyCode)),
                        icon: "person.crop.circle.fill.badge.checkmark"
                        
                    )

                    DashboardCardView(
                        title: "Members",
                        value: "\(stats.memberCount)",
                        icon: "person.2.fill"
                        
                    )
                }

                HStack(spacing: 12) {
                    DashboardCardView(
                        title: "You Owe",
                        value: stats.youOwe.formatted(.currency(code: settings.currencyCode)),
                        icon: "arrow.up.circle.fill"
                        
                    )

                    DashboardCardView(
                        title: "You Are Owed",
                        value: stats.youAreOwed.formatted(.currency(code: settings.currencyCode)),
                        icon: "arrow.down.circle.fill"
                    )
                }

                DashboardCardView(
                    title: "Expenses",
                    value: "\(stats.expenseCount)",
                    icon: "creditcard.fill"
                )

            }
            .listRowBackground(Color.clear)
            

            Section("Members") {
                ForEach(group.members) { member in
                    NavigationLink {
                        EditMemberView(member: member)
                    } label: {
                        HStack {
                            InitialAvatarView(name: member.name)

                            Text(member.name)
                                .font(.headline)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteMembers)

                Button {
                    showingAddMember = true
                } label: {
                    Label("Add Member", systemImage: "plus.circle.fill")
                }
            }

            Section {
                Button {
                    showingAddExpense = true
                } label: {
                    Label("Add Expense", systemImage: "plus.circle.fill")
                }
                
                Button {
                    showingRestaurantSplit = true
                } label: {
                    Label("Add Restaurant Split", systemImage: "fork.knife")
                }

            }
            
            

            if filteredExpenses.isEmpty {
                Section("Expenses") {
                    ContentUnavailableView(
                        "No Expenses",
                        systemImage: "creditcard",
                        description: Text("Tap Add Expense to record your first shared cost.")
                    )
                }
            } else {
                ForEach(groupedExpenses, id: \.title) { groupSection in
                    Section(groupSection.title) {
                        ForEach(groupSection.expenses) { expense in
                            NavigationLink {
                                EditExpenseView(group: group, expense: expense)
                            } label: {
                                ExpenseRowView(expense: expense)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteExpense(expense)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                NavigationLink {
                                    EditExpenseView(group: group, expense: expense)
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                            .contextMenu {
                                Button {
                                    duplicateExpense(expense)
                                } label: {
                                    Label("Duplicate", systemImage: "doc.on.doc")
                                }

                                Divider()

                                Button(role: .destructive) {
                                    deleteExpense(expense)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete(perform: deleteExpenses)
                    }
                }
            }

            Section {
                NavigationLink("View Balances") {
                    BalanceView(group: group)
                }
            }
            
            Section {

                NavigationLink {

                    StatisticsView(group: group)

                } label: {

                    Label(
                        "Statistics",
                        systemImage: "chart.bar.fill"
                    )

                }

            }
            
            Section("Recent Activity") {
                if group.activities.isEmpty {
                    Text("No recent activity")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(group.activities.sorted { $0.date > $1.date }.prefix(5)) { activity in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(activity.title)
                                .font(.headline)

                            Text(activity.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text(activity.date, style: .relative)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    shareGroupSummary()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(item: $shareURL) { url in
            ShareSheet(items: [url])
        }
        
        .searchable(text: $searchText, prompt: "Search expenses")
        .navigationTitle(group.name)
        .sheet(isPresented: $showingAddMember) {
            AddMemberView(group: group)
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(group: group)
        }
        .sheet(isPresented: $showingRestaurantSplit) {
            AddRestaurantExpenseView(group: group)
        }
    }
    
    private var filteredExpenses: [Expense] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return group.expenses
        }

        let query = searchText.lowercased()

        return group.expenses.filter { expense in
            expense.title.lowercased().contains(query) ||
            expense.category.lowercased().contains(query) ||
            (expense.paidBy?.name.lowercased().contains(query) ?? false)
        }
    }
    
    private var settings: AppSettings {
        UserSettingsHelper.currentSettings(from: modelContext)
    }

    private var stats: GroupStats {
        GroupStatsCalculator.stats(for: group, userName: settings.userName)
    }
    
    private func deleteExpense(_ expense: Expense) {
        if let index = group.expenses.firstIndex(where: {
            $0.persistentModelID == expense.persistentModelID
        }) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                group.expenses.remove(at: index)
                Haptics.warning()
            }
        }
    }
    
    private func deleteExpenses(at offsets: IndexSet) {
        for index in offsets {
            let expense = filteredExpenses[index]

            if let originalIndex = group.expenses.firstIndex(where: {
                $0.persistentModelID == expense.persistentModelID
            }) {
                group.expenses.remove(at: originalIndex)
                Haptics.warning()
            }
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
            Haptics.warning()
        }
    }
    
    
    private func duplicateExpense(_ expense: Expense) {
        let copiedExpense = Expense(
            title: expense.title + " Copy",
            amount: expense.amount,
            paidBy: expense.paidBy,
            group: group,
            participants: expense.participants,
            category: expense.category,
            subtotal: expense.subtotal,
            tax: expense.tax,
            tipPercentage: expense.tipPercentage,
            splitMethod: expense.splitMethod,
            receiptImageData: expense.receiptImageData
        )

        group.expenses.append(copiedExpense)

        let activity = ActivityItem(
            title: "Duplicated expense",
            detail: "\(copiedExpense.title) • \(copiedExpense.amount.formatted(.currency(code: "USD")))",
            group: group
        )

        group.activities.append(activity)

        Haptics.success()
    }
    
    
    private var groupedExpenses: [(title: String, expenses: [Expense])] {
        let calendar = Calendar.current

        let sortedExpenses = filteredExpenses.sorted {
            $0.date > $1.date
        }

        let groups = Dictionary(grouping: sortedExpenses) { expense in
            if calendar.isDateInToday(expense.date) {
                return "Today"
            } else if calendar.isDateInYesterday(expense.date) {
                return "Yesterday"
            } else {
                return expense.date.formatted(date: .abbreviated, time: .omitted)
            }
        }

        return groups
            .map { (title: $0.key, expenses: $0.value) }
            .sorted {
                let firstDate = $0.expenses.first?.date ?? .distantPast
                let secondDate = $1.expenses.first?.date ?? .distantPast
                return firstDate > secondDate
            }
    }
}
