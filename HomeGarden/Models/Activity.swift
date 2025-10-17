//==================================================//
//  MARK: - Activity.swift
//  作成者: konishi
//  作成日: 2025/10/17
//  説明  : 作物の作業情報を管理するモデルと作業タイプ列挙型
//==================================================//

import Foundation
import SwiftData

//==================================================//
//  MARK: - モデルクラス
//==================================================//

/// 作業情報を管理する SwiftData モデル
@Model
class Activity: Identifiable {
    
    //==================================================//
    //  MARK: - 属性
    //==================================================//
    
    /// 作業日
    @Attribute var date: Date
    
    /// 作業タイプ
    @Attribute var type: ActivityType
    
    /// 作業数量（任意）
    @Attribute var quantity: Int?
    
    /// 作業コメント（任意）
    @Attribute var comment: String?
    
    //==================================================//
    //  MARK: - イニシャライザ
    //==================================================//
    
    /// Activity 初期化
    /// - Parameters:
    ///   - date: 作業日（デフォルトは現在日時）
    ///   - type: 作業タイプ
    ///   - quantity: 作業数量（任意）
    ///   - comment: 作業コメント（任意）
    ///   - crop: 紐づく作物（未使用だが将来の拡張用）
    init(date: Date = Date(), type: ActivityType, quantity: Int? = nil, comment: String? = nil, crop: Crop) {
        self.date = date
        self.type = type
        self.quantity = quantity
        self.comment = comment
    }
}

//==================================================//
//  MARK: - 列挙型
//==================================================//

/// 作業タイプを管理する列挙型
enum ActivityType: Int, Codable, CaseIterable, Identifiable {
    
    /// Identifiable 用の id
    var id: Int { rawValue }
    
    case sowing, watering, fertilizing, harvesting
    
    /// 表示用名称
    var displayName: String {
        switch self {
        case .sowing: return "種まき"
        case .watering: return "水やり"
        case .fertilizing: return "追肥"
        case .harvesting: return "収穫"
        }
    }
}

