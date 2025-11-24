//
//  PreviewData.swift
//  HomeGarden
//  
//  Created by konishi on 2025/11/16
//  
//

import Foundation
import SwiftData


//==================================================//
//  MARK: - プレビュー用拡張
//==================================================//

struct PreviewData {
    
    //==================================================//
    // MARK: - 複数 Crop + Activity（デバッグ用）
    //==================================================//
    @MainActor
    static var cropsWithActivities: ModelContainer {
        let container = try! ModelContainer(
            for: Crop.self, Activity.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = container.mainContext
        
        // --- 作物を作成 ---
        let tomato = Crop(orderIndex: 1, name: "トマト", unit: .piece, color: .red, icon: .tomato)
        let broccoli = Crop(orderIndex: 2, name: "ブロッコリー", unit: .piece, color: .green, icon: .broccoli)
        let carrot = Crop(orderIndex: 3, name: "にんじん", unit: .piece, color: .green, icon: .carrot)
        
        context.insert(tomato)
        context.insert(broccoli)
        context.insert(carrot)
        
        // --- トマトに Activity 追加 ---
        let a1 = Activity(date: .now, activity: .watering, quantity: 3, comment: "朝 3L", crop: tomato)
        let a2 = Activity(date: .now.addingTimeInterval(-86400), activity: .harvest, quantity: nil, comment: "液肥", crop: tomato)
        
        tomato.activities.append(contentsOf: [a1, a2])
        context.insert(a1)
        context.insert(a2)
        
        // --- ブロッコリーに Activity ---
        let b1 = Activity(date: .now, activity: .harvest, quantity: 1, comment: "初収穫！", crop: broccoli)
        broccoli.activities.append(b1)
        context.insert(b1)
        
        return container
    }
    
    //==================================================//
    // MARK: - Crop だけ（一覧画面用）
    //==================================================//
    @MainActor
    static var cropsOnly: ModelContainer {
        let container = try! ModelContainer(
            for: Crop.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        _ = container.mainContext
        
        container.mainContext.insert(Crop(orderIndex: 1, name: "トマト", unit: .piece, color: .red, icon: .tomato))
        container.mainContext.insert(Crop(orderIndex: 2, name: "ブロッコリー", unit: .piece, color: .green, icon: .broccoli))
        container.mainContext.insert(Crop(orderIndex: 3, name: "にんじん", unit: .piece, color: .green, icon: .carrot))
        container.mainContext.insert(Crop(orderIndex: 4, name: "たまねぎ", unit: .piece, color: .red, icon: .onion))
        container.mainContext.insert(Crop(orderIndex: 5, name: "にんにく", unit: .piece, color: .orange, icon: .garlic))
        
        return container
    }
    
    //==================================================//
    // MARK: - 単品 Crop（Form の確認用）
    //==================================================//
    @MainActor
    static var singleCrop: ModelContainer {
        let container = try! ModelContainer(
            for: Crop.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        container.mainContext.insert(
            Crop(orderIndex: 1, name: "トマト", unit: .piece, color: .red, icon: .tomato)
        )
        return container
    }
    
    //==================================================//
    // MARK: - 空データ（新規 UI 確認用）
    //==================================================//
    @MainActor
    static var empty: ModelContainer {
        try! ModelContainer(
            for: Crop.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }
    
    //==================================================//
    //  MARK: - ListActivityView 用データ
    //==================================================//
        
        /// ListActivityView のためのサンプルデータ
        @MainActor
        static var listActivityView: (container: ModelContainer, crop: Crop) {
            
            let container = try! ModelContainer(
                for: Crop.self, Activity.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            
            let context = container.mainContext
            
            // --- 対象の作物（トマト） ---
            let tomato = Crop(
                orderIndex: 1,
                name: "トマト", unit: .piece,
                color: .red, icon: .tomato
            )
            context.insert(tomato)
            
            // --- Activity ---
            let a1 = Activity(
                date: Date(),
                activity: .watering,
                quantity: 3,
                comment: "たっぷり3L",
                crop: tomato
            )
            
            let a2 = Activity(
                date: Date().addingTimeInterval(-86400 * 1),
                activity: .germination,
                quantity: nil,
                comment: "液肥を薄めて施肥",
                crop: tomato
            )
            
            let a3 = Activity(
                date: Date().addingTimeInterval(-86400 * 3),
                activity: .harvest,
                quantity: 5,
                comment: "初収穫！",
                crop: tomato
            )
            
            tomato.activities.append(contentsOf: [a1, a2, a3])
            context.insert(a1)
            context.insert(a2)
            context.insert(a3)
            
            return (container, tomato)
        }
        
        /// CalendarView 用のプレビュー（Crop + Activity）
        @MainActor
        static var calendarSample: ModelContainer {
            let container = try! ModelContainer(
                for: Crop.self, Activity.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            let context = container.mainContext
            
            let crop = Crop(orderIndex: 0, name: "トマト", unit: .piece, color: .red, icon: .tomato)
            
            let act1 = Activity(
                date: Date(),
                activity: .watering,
                quantity: 3,
                comment: "たっぷり水やり",
                crop: crop
            )
            
            let act2 = Activity(
                date: Date().addingTimeInterval(-86400 * 2),
                activity: .flowering,
                quantity: nil,
                comment: "追肥",
                crop: crop
            )
            
            crop.activities = [act1, act2]
            
            context.insert(crop)
            context.insert(act1)
            context.insert(act2)
            
            return container
        }


}

