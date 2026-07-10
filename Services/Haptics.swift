import UIKit
import SwiftData

struct Haptics {

    private static var enabled: Bool {
        guard
            let container = try? ModelContainer(for: AppSettings.self),
            let settings = try? container.mainContext.fetch(
                FetchDescriptor<AppSettings>()
            ).first
        else {
            return true
        }

        return settings.hapticsEnabled
    }

    static func success() {
        guard enabled else { return }

        UINotificationFeedbackGenerator()
            .notificationOccurred(.success)
    }

    static func warning() {
        guard enabled else { return }

        UINotificationFeedbackGenerator()
            .notificationOccurred(.warning)
    }

    static func light() {
        guard enabled else { return }

        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
    }

    static func medium() {
        guard enabled else { return }

        UIImpactFeedbackGenerator(style: .medium)
            .impactOccurred()
    }
}
