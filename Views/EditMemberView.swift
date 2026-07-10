import SwiftUI
import SwiftData

struct EditMemberView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var member: Member

    @State private var name = ""

    var body: some View {
        Form {
            Section("Member Name") {
                TextField("Name", text: $name)
            }
        }
        .navigationTitle("Edit Member")
        .onAppear {
            name = member.name
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    member.name = name.trimmingCharacters(in: .whitespaces)
                    Haptics.success()
                    dismiss()
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
}
