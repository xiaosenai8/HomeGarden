//==================================================//
//  MARK: - CropIcon.swift
//  作成者: konishi
//  作成日: 2025/10/07
//  説明  : 作物のアイコンを表す enum。表示名・システムアイコン名を管理
//==================================================//

import Foundation
import SwiftUI

//==================================================//
//  MARK: - 作物アイコン Enum
//==================================================//
enum CropIcon: Int, Codable, CaseIterable, Identifiable {
    
    var id: Int { rawValue }
    
    case tomato   = 1
    case eggplant = 2
    case cucumber = 3
}

//==================================================//
//  MARK: - 表示名
//==================================================//
extension CropIcon {
    
    /// 日本語での作物名
    var displayName: String {
        switch self {
        case .tomato:   return "トマト"
        case .eggplant: return "ナス"
        case .cucumber: return "きゅうり"
        }
    }
}

//==================================================//
//  MARK: - システムアイコン名
//==================================================//
extension CropIcon {
    
    /// SwiftUI で使用する SF Symbols 名
    var systemIconName: String {
        switch self {
        case .tomato:   return "sun.min"
        case .eggplant: return "moon"
        case .cucumber: return "cloud"
        }
    }
}

