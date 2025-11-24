//==================================================//
//  MARK: - Util.swift
//  作成者: konishi
//  作成日: 2025/10/17
//  説明  : 日付関連のユーティリティ拡張
//==================================================//

import Foundation
import SwiftUI

//==================================================//
//  MARK: - Date 拡張
//==================================================//

extension Date {
    
    /// 日本語形式で日付文字列を取得
    /// - Returns: "yyyy年M月d日" 形式の文字列
    var formattedJapaneseDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "Y/M/d"
        return formatter.string(from: self)
    }
}

//==================================================//
//  MARK: - Color 拡張
//==================================================//

extension Color {
    
    /// Color → Hex 文字列
    var hexString: String {
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X",
                      Int(r * 255), Int(g * 255), Int(b * 255))
    }
    
    /// Hex → Color
    static func fromHex(_ hex: String) -> Color {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        return Color(
            red: Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8) & 0xFF) / 255,
            blue: Double(rgb & 0xFF) / 255
        )
    }
}

//==================================================//
//  MARK: - Crop 拡張
//==================================================//

extension Crop {
    /// 画面表示用の実際のColor（custom含む）
    var displayColor: Color {
        if color == .custom, let hex = customColorHex {
            return Color.fromHex(hex)
        } else {
            return color.cropColor
        }
    }
}
