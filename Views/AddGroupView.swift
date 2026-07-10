import SwiftUI
import SwiftData

struct AddGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var groupName = ""
    @State private var selectedIcon = "house.fill"

    let icons = [
        "house.fill",
        "airplane",
        "fork.knife",
        "graduationcap.fill",
        "briefcase.fill",
        "party.popper.fill"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Group Name") {
                    TextField("Example: Vegas Trip", text: $groupName)
                }

                Section("Icon") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                        ForEach(icons, id: \.self) { icon in
                            Button {
                                selectedIcon = icon
                            } label: {
                                Image(systemName: icon)
                                    .font(.title)
                                    .frame(width: 60, height: 60)
                                    .background(selectedIcon == icon ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("New Group")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedName = groupName.trimmingCharacters(in: .whitespaces)

                        let group = Group(name: trimmedName, icon: selectedIcon)

                        modelContext.insert(group)

                        do {
                            try modelContext.save()
                        } catch {
                            print("Failed to save group: \(error)")
                        }

                        dismiss()
                    }
                    .disabled(groupName.trimmingCharacters(in: .whitespaces).isEmpty)                }
            }
        }
    }
}
