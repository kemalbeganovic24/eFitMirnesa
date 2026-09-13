//
//  Item.swift
//  eFitMirnesa
//
//  Created by Kemal Beganovic on 21. 8. 2026..
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
