import Foundation
import SwiftData

@Model
final class Group {
    var name: String
    var icon: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Member.group)
    var members: [Member] = []

    @Relationship(deleteRule: .cascade, inverse: \Expense.group)
    var expenses: [Expense] = []
    
    @Relationship(deleteRule: .cascade, inverse: \ActivityItem.group)
    var activities: [ActivityItem] = []
    
    @Relationship(deleteRule: .cascade, inverse: \Payment.group)
    var payments: [Payment] = []

    init(name: String, icon: String = "person.3.fill") {
        self.name = name
        self.icon = icon
        self.createdAt = Date()
    }
}
