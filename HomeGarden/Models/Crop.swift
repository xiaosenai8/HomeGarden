//==================================================//
//  MARK: - Crop.swift
//  作成者: konishi
//  作成日: 2025/10/17
//  説明  : 作物の情報を管理するモデルクラス
//==================================================//

import Foundation
import SwiftData

//==================================================//
//  MARK: - モデルクラス
//==================================================//

/// 作物情報を管理する SwiftData モデル
@Model
class Crop {
    
    //==================================================//
    //  MARK: - 属性
    //==================================================//
    
    /// 並び順インデックス
    var orderIndex: Int = 0
    
    /// 作物名
    var name: String
    
    /// 単位
    var unit: CropUnit {
        get { CropUnit(rawValue: colorValue) ?? .piece }
        set { colorValue = newValue.rawValue }
    }

    /// カラー（列挙型として扱う computed property）
    var color: CropColor {
        get { CropColor(rawValue: colorValue) ?? .green }
        set { colorValue = newValue.rawValue }
    }
    
    /// カスタムカラー
    var customColorHex: String?
    
    /// アイコン（列挙型として扱う computed property）
    var icon: CropIcon {
        get { CropIcon(rawValue: iconValue) ?? .tomato }
        set { iconValue = newValue.rawValue }
    }
    
    /// アーカイブ済みかどうか
    var isArchived: Bool = false
    
    /// 関連する作業のリスト
    @Relationship var activities: [Activity] = []

    
    /// 保存用のアイコン値
    var iconValue: Int = CropIcon.tomato.rawValue
    
    /// 保存用のカラー値
    var colorValue: Int = CropColor.green.rawValue

    
    //==================================================//
    //  MARK: - イニシャライザ
    //==================================================//
    
    /// Crop 初期化
    /// - Parameters:
    ///   - orderIndex: 並び順インデックス
    ///   - name: 作物名
    ///   - icon: 作物アイコン
    ///   - color: 作物カラー
    init(orderIndex: Int, name: String, unit:CropUnit, color: CropColor, customColorHex: String? = nil, icon: CropIcon) {
        self.orderIndex = orderIndex
        self.name = name
        self.unit = unit
        self.colorValue = color.rawValue
        self.customColorHex = customColorHex
        self.iconValue = icon.rawValue
    }
}

