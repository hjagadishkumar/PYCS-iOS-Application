//
//  Item.swift
//  AlfalfaYield
//
//  Created by Anusha Challa on 9/16/24.
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
