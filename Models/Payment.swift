import Foundation
import SwiftData

@Model
final class Payment {
    var fromName: String
    var toName: String
    var amount: Double
    var date: Date
    var group: Group?

    init(fromName: String, toName: String, amount: Double, group: Group?) {
        self.fromName = fromName
        self.toName = toName
        self.amount = amount
        self.date = Date()
        self.group = group
    }
}
