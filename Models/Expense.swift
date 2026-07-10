import Foundation
import SwiftData

@Model
final class Expense {
    var title: String
    var amount: Double
    var date: Date
    var category: String = "Other"

    var paidBy: Member?
    var group: Group?

    @Relationship
    var participants: [Member] = []

    init(
        title: String,
        amount: Double,
        paidBy: Member?,
        group: Group?,
        participants: [Member],
        category: String = "Other"
    ) {
        self.title = title
        self.amount = amount
        self.date = Date()
        self.paidBy = paidBy
        self.group = group
        self.participants = participants
        self.category = category
    }
}
