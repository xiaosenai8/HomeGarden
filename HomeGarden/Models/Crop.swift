//
//  Crop.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/05
//  
//

import Foundation
import SwiftData

@Model
class Crop{

    var orderIndex: Int = 0
    var name: String
    
// TODO: 追加
//    var icon: Icon
//    var colors: Colors
//    @Attribute(.unique) var id: UUID
    
    init(orderIndex: Int, name: String, ) {
        self.orderIndex = orderIndex
        self.name = name
        
// TODO: 追加
//        self.icon = icon
//        self.colors = colors
//        self.id = UUID()
    }
}

extension Crop{
    @MainActor
    static var preview: ModelContainer{
        let container = try! ModelContainer(for: Crop.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        container.mainContext.insert(Crop(orderIndex: 1,name: "トマト"))
        container.mainContext.insert(Crop(orderIndex: 2,name: "なす"))
        container.mainContext.insert(Crop(orderIndex: 3,name: "ピーマン"))
        container.mainContext.insert(Crop(orderIndex: 4,name: "いちご"))
        container.mainContext.insert(Crop(orderIndex: 5,name: "にんにく"))
        
        return container
    }
}

