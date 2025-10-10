//
//  Crop.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/05
//  
//

import Foundation
import SwiftData

//==================================================//
//  MARK: - クラス
//==================================================//
@Model
class Crop{

    //==================================================//
    //  MARK: - 変数
    //==================================================//
    var orderIndex: Int = 0
    var name: String
    
    // enumとして扱うためのcomputed property
    var icon: CropIcon {
        get { CropIcon(rawValue: iconValue) ?? .tomato }
        set { iconValue = newValue.rawValue }
    }
    var color: CropColor {
        get { CropColor(rawValue: colorValue) ?? .teal }
        set { colorValue = newValue.rawValue }
    }

    // 実際に保存する値はInt
    var iconValue: Int = CropIcon.tomato.rawValue
    var colorValue: Int = CropColor.teal.rawValue

    
    //==================================================//
    //  MARK: - 初期化
    //==================================================//
    init(orderIndex: Int, name: String, icon: CropIcon, color: CropColor) {
        self.orderIndex = orderIndex
        self.name = name
        self.iconValue = icon.rawValue
        self.colorValue = color.rawValue
    }
}

extension Crop{
    @MainActor
    static var preview: ModelContainer{
        let container = try! ModelContainer(for: Crop.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
//        container.mainContext.insert(Crop(orderIndex: 1,name: "トマト"))
//        container.mainContext.insert(Crop(orderIndex: 2,name: "なす"))
//        container.mainContext.insert(Crop(orderIndex: 3,name: "ピーマン"))
//        container.mainContext.insert(Crop(orderIndex: 4,name: "いちご"))
//        container.mainContext.insert(Crop(orderIndex: 5,name: "にんにく"))
        
        container.mainContext.insert(Crop(orderIndex: 1,name: "トマト", icon: .tomato, color: .red))
        container.mainContext.insert(Crop(orderIndex: 2,name: "なす", icon: .cucumber, color: .teal))
        container.mainContext.insert(Crop(orderIndex: 3,name: "ピーマン", icon: .eggplant, color: .green))
        container.mainContext.insert(Crop(orderIndex: 4,name: "いちご", icon: .cucumber, color: .red))
        container.mainContext.insert(Crop(orderIndex: 5,name: "にんにく", icon: .eggplant, color: .orange))
        
        return container
    }
}

