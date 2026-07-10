import Foundation
import SwiftData

@Model
final class ActivityItem {
    var title: String
    var detail: String
    var date: Date
    var group: Group?

    init(title: String, detail: String, group: Group?) {
        self.title = title
        self.detail = detail
        self.date = Date()
        self.group = group
    }
}
