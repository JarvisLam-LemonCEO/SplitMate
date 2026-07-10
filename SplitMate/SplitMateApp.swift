import SwiftUI
import SwiftData

@main
struct SplitMateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Group.self,
            Member.self,
            Expense.self,
            AppSettings.self
        ])
    }
}
