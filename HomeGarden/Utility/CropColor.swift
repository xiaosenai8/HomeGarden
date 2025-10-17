//==================================================//
//  MARK: - CropColor.swift
//  作成者: konishi
//  作成日: 2025/10/17
//  説明  : 作物の色を管理する列挙型
//==================================================//

import Foundation
import SwiftUI

//==================================================//
//  MARK: - 列挙型
//==================================================//

/// 作物のカラーを管理する列挙型
/// - Note: 保存は Int 値として行う
enum CropColor: Int, Codable, CaseIterable, Identifiable {
    
    //==================================================//
    //  MARK: - Identifiable
    //==================================================//
    
    var id: Int { rawValue }
    
    //==================================================//
    //  MARK: - ケース
    //==================================================//
    
    case teal      = 1
    case green     = 2
    case red       = 3
    case brown     = 4
    case orange    = 5
    case yellow    = 6
}

//==================================================//
//  MARK: - 拡張: SwiftUI Color
//==================================================//

extension CropColor {
    
    /// SwiftUI の Color に変換
    var cropColor: Color {
        switch self {
        case .teal:   return .teal
        case .green:  return .green
        case .red:    return .red
        case .brown:  return .brown
        case .orange: return .orange
        case .yellow: return .yellow
        }
    }
}

