import Foundation
import SwiftData

@Model
final class Expense {
    var title: String
    var amount: Double
    var date: Date
    var category: String = "Other"

    var subtotal: Double?
    var tax: Double?
    var tipPercentage: Double?
    var splitMethod: String = "Equal"

    var paidBy: Member?
    var group: Group?

    @Relationship
    var participants: [Member] = []

    @Attribute(.externalStorage)
    var receiptImageData: Data?

    init(
        title: String,
        amount: Double,
        paidBy: Member?,
        group: Group?,
        participants: [Member],
        category: String = "Other",
        subtotal: Double? = nil,
        tax: Double? = nil,
        tipPercentage: Double? = nil,
        splitMethod: String = "Equal",
        receiptImageData: Data? = nil
    ) {
        self.title = title
        self.amount = amount
        self.date = Date()
        self.paidBy = paidBy
        self.group = group
        self.participants = participants
        self.category = category
        self.subtotal = subtotal
        self.tax = tax
        self.tipPercentage = tipPercentage
        self.splitMethod = splitMethod
        self.receiptImageData = receiptImageData
    }
}
