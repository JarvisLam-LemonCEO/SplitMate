import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var groups: [Group] = []
    @State private var showingSettings = false
    @State private var showingAddGroup = false

    @Query private var settings: [AppSettings]

    var body: some View {
        NavigationStack {
            List {
                if groups.isEmpty {
                    ContentUnavailableView(
                        "No Groups Yet",
                        systemImage: "person.3",
                        description: Text("Tap + to create your first split group.")
                    )
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(groups) { group in
                        NavigationLink {
                            GroupDetailView(group: group)
                        } label: {
                            GroupRowView(
                                group: group,
                                userName: currentSettings.userName,
                                currencyCode: currentSettings.currencyCode
                            )
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 6)
                    }
                    .onDelete(perform: deleteGroups)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .refreshable {
                fetchGroups()
            }
            .navigationTitle("SplitMate")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddGroup = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .preferredColorScheme(colorScheme)
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingAddGroup, onDismiss: {
                fetchGroups()
            }) {
                AddGroupView()
            }
            .onAppear {
                fetchGroups()
            }
        }
    }

    private var currentSettings: AppSettings {
        UserSettingsHelper.currentSettings(from: modelContext)
    }

    private var colorScheme: ColorScheme? {
        switch settings.first?.appearance ?? "System" {
        case "Light":
            return .light
        case "Dark":
            return .dark
        default:
            return nil
        }
    }

    private func fetchGroups() {
        let descriptor = FetchDescriptor<Group>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        do {
            groups = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch groups: \(error)")
        }
    }

    private func deleteGroups(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(groups[index])
        }

        do {
            try modelContext.save()
            fetchGroups()
        } catch {
            print("Failed to delete group: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(
            for: [Group.self, Member.self, Expense.self, AppSettings.self],
            inMemory: true
        )
}
