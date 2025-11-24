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
    
    case tomato               = 1
    case radish               = 2
    case onion                = 3
    case japaneseWhiteRadish  = 4
    case garlic               = 5
    case chineseCabbage       = 6
    case carrot               = 7
    case broccoli             = 8
}

//==================================================//
//  MARK: - システムアイコン名
//==================================================//
extension CropIcon {
    
    /// SwiftUI で使用する SF Symbols 名
    var iconName: String {
        switch self {
        case .tomato:
            "tomato"
        case .radish:
            "radish"
        case .onion:
            "onion"
        case .japaneseWhiteRadish:
            "japaneseWhiteRadish"
        case .garlic:
            "garlic"
        case .chineseCabbage:
            "chineseCabbage"
        case .carrot:
            "carrot"
        case .broccoli:
            "broccoli"
        }
    }
}


