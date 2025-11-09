//==================================================//
//  MARK: - CropColor.swift
//  作成者: konishi
//  作成日: 2025/10/17
//  説明  : 作物の色を管理する列挙型
//==================================================//

import Foundation
import SwiftUI
import UIKit

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
    
    case green      = 1
    case orange     = 2
    case yellow     = 3
    case red        = 4
    case custom     = 5
}

//==================================================//
//  MARK: - 拡張: SwiftUI Color
//==================================================//

extension CropColor {
    
    /// SwiftUI の Color に変換
    var cropColor: Color {
        switch self {
        case .green:  return .green
        case .orange: return .orange
        case .yellow: return .yellow
        case .red:    return .red
        case .custom: return .clear
        }
    }
}

