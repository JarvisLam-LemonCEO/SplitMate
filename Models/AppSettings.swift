import Foundation
import SwiftData

@Model
final class AppSettings {
    var userName: String
    var currencyCode: String
    var appearance: String
    var hapticsEnabled: Bool

    init(
        userName: String = "You",
        currencyCode: String = "USD",
        appearance: String = "System",
        hapticsEnabled: Bool = true
    ) {
        self.userName = userName
        self.currencyCode = currencyCode
        self.appearance = appearance
        self.hapticsEnabled = hapticsEnabled
    }
}
