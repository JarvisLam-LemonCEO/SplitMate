import Foundation
import SwiftData

@Model
final class Member {
    var name: String
    var createdAt: Date
    var group: Group?

    init(name: String, group: Group? = nil) {
        self.name = name
        self.createdAt = Date()
        self.group = group
    }
}
