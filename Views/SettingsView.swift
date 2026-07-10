import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var userName = ""
    @State private var currencyCode = "USD"
    @State private var appearance = "System"
    @State private var hapticsEnabled = true
    
    let appearances = ["System", "Light", "Dark"]
    let currencies = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD", "HKD"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Your Profile") {
                    TextField("Your name", text: $userName)
                }
                
                Section("Appearance") {
                    Picker("Mode", selection: $appearance) {
                        ForEach(appearances, id: \.self) { mode in
                            Text(mode).tag(mode)
                        }
                    }
                }
                
                Section("Feedback") {
                    Toggle("Enable Haptics", isOn: $hapticsEnabled)
                }

                Section("Currency") {
                    Picker("Currency", selection: $currencyCode) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                loadSettings()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        saveSettings()
                        dismiss()
                    }
                }
            }
        }
    }

    private func loadSettings() {
        let descriptor = FetchDescriptor<AppSettings>()

        if let settings = try? modelContext.fetch(descriptor).first {
            userName = settings.userName
            appearance = settings.appearance
            currencyCode = settings.currencyCode
            hapticsEnabled = settings.hapticsEnabled
        } else {
            userName = "You"
            currencyCode = "USD"
            appearance = "System"
            hapticsEnabled = true
        }
    }

    private func saveSettings() {
        let descriptor = FetchDescriptor<AppSettings>()

        if let settings = try? modelContext.fetch(descriptor).first {
            settings.userName = userName
            settings.appearance = appearance
            settings.currencyCode = currencyCode
            settings.hapticsEnabled = hapticsEnabled
        } else {
            let settings = AppSettings(
                userName: userName,
                currencyCode: currencyCode,
                appearance: appearance,
                hapticsEnabled: hapticsEnabled
            )
            modelContext.insert(settings)
        }

        try? modelContext.save()
    }
}
