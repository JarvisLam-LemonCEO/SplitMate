import SwiftUI

struct InitialAvatarView: View {
    let name: String

    private var initial: String {
        String(name.trimmingCharacters(in: .whitespaces).prefix(1)).uppercased()
    }

    var body: some View {
        Text(initial.isEmpty ? "?" : initial)
            .font(.headline)
            .foregroundStyle(.white)
            .frame(width: 36, height: 36)
            .background(Color.blue.gradient)
            .clipShape(Circle())
    }
}
