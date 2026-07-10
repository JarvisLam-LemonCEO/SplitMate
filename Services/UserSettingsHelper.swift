import Foundation
import SwiftData

struct UserSettingsHelper {
    static func currentSettings(from context: ModelContext) -> AppSettings {
        let descriptor = FetchDescriptor<AppSettings>()

        if let settings = try? context.fetch(descriptor).first {
            return settings
        }

        let settings = AppSettings()
        context.insert(settings)
        try? context.save()
        return settings
    }
}
