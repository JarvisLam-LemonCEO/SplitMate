import Foundation
import SwiftData

@Model
final class AppSettings {
    var userName: String
    var currencyCode: String
    var appearance: String

    init(
        userName: String = "You",
        currencyCode: String = "USD",
        appearance: String = "System"
    ) {
        self.userName = userName
        self.currencyCode = currencyCode
        self.appearance = appearance
    }
}
