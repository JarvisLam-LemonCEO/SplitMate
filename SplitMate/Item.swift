//
//  Item.swift
//  SplitMate
//
//  Created by Jarvis Lam on 7/9/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
