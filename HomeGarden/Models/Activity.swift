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
    
    /// 作業タイプ（列挙型として扱う computed property）
    var activity: ActivityType {
        get { ActivityType(rawValue: activityValue) ?? .watering }
        set { activityValue = newValue.rawValue }
   }
    
    /// 保存用の値
    @Attribute var activityValue: Int = ActivityType.watering.rawValue
    
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
    init(date: Date = Date(), activity: ActivityType, quantity: Int? = nil, comment: String? = nil) {
        self.date = date
        self.activityValue = activity.rawValue
        self.quantity = quantity
        self.comment = comment
    }
}

