//
//  Activity.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/10
//  
//

import Foundation
import SwiftData

@Model
class Activity: Identifiable {
    @Attribute var id: UUID = UUID()
    @Attribute var date: Date
    @Attribute var type: ActivityType
    @Attribute var quantity: Int?
    
//    @Relationship(inverse: \Crop.activities)
//    var crop: Crop
    
    init(date: Date = Date(), type: ActivityType, quantity: Int? = nil, crop: Crop) {
        self.date = date
        self.type = type
        self.quantity = quantity
//        self.crop = crop
    }
}

// 作業タイプの enum
enum ActivityType: Int, Codable, CaseIterable, Identifiable {
    var id: Int { rawValue }
    
    case sowing, watering, fertilizing, harvesting
    
    var displayName: String {
        switch self {
        case .sowing: return "種まき"
        case .watering: return "水やり"
        case .fertilizing: return "追肥"
        case .harvesting: return "収穫"
        }
    }
}
