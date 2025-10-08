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
    var id: UUID
    var name: String
    var icon: Icon
    var colors: Colors
    
    init(name: String, icon: Icon, colors: Colors) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.colors = colors
    }
}

extension Crop{
    @MainActor
    static var preview: ModelContainer{
        let container = try! ModelContainer(for: Crop.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        container.mainContext.insert(Crop(name: "トマト", icon: Icon(rawValue: 1)!, colors: Colors(rawValue: 1)!))
        container.mainContext.insert(Crop(name: "なす", icon: Icon(rawValue: 2)!, colors: Colors(rawValue: 2)!))
        container.mainContext.insert(Crop(name: "ピーマン", icon: Icon(rawValue: 3)!, colors: Colors(rawValue: 3)!))
        container.mainContext.insert(Crop(name: "いちご", icon: Icon(rawValue: 1)!, colors: Colors(rawValue: 4)!))
        container.mainContext.insert(Crop(name: "にんにく", icon: Icon(rawValue: 2)!, colors: Colors(rawValue: 5)!))
        
        return container
    }
}

