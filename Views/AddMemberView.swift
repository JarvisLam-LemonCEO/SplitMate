import SwiftUI
import SwiftData

struct AddMemberView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""

    @Bindable var group: Group

    var body: some View {

        NavigationStack {

            Form {

                TextField("Member Name", text: $name)

            }

            .navigationTitle("New Member")

            .toolbar {

                ToolbarItem(placement: .cancellationAction) {

                    Button("Cancel") {
                        dismiss()
                    }

                }

                ToolbarItem(placement: .confirmationAction) {

                    Button("Save") {

                        let member = Member(name: name)

                        member.group = group

                        group.members.append(member)

                        dismiss()

                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)

                }

            }

        }

    }

}
