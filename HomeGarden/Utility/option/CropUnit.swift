//==================================================//
//  MARK: - CropUnit.swift
//  作成者: konishi
//  作成日: 2025/10/07
//  説明  : 単位表す enum。表示名・システムアイコン名を管理
//==================================================//

import Foundation
import SwiftUI

//==================================================//
//  MARK: - 単位 Enum
//==================================================//
enum CropUnit: Int, Codable, CaseIterable, Identifiable {
    
    var id: Int { rawValue }
    
    case piece = 1
    case stick = 2
    case ball = 3
    case stock = 4
    case bunch = 5
    case sheet = 6
    case kg = 7
    case g = 8
    
}

extension CropUnit {
    
    /// SwiftUI で使用する SF Symbols 名
    var unitName: String {
        switch self {

        case .piece:
            "個"
        case .stick:
            "本"
        case .ball:
            "玉"
        case .stock:
            "株"
        case .bunch:
            "束"
        case .sheet:
            "枚"
        case .kg:
            "Kg"
        case .g:
            "g"
        }
    }
}
