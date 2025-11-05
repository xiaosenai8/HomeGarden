//==================================================//
//  MARK: - Util.swift
//  作成者: konishi
//  作成日: 2025/10/17
//  説明  : 日付関連のユーティリティ拡張
//==================================================//

import Foundation

//==================================================//
//  MARK: - Date 拡張
//==================================================//

extension Date {
    
    /// 日本語形式で日付文字列を取得
    /// - Returns: "yyyy年M月d日" 形式の文字列
    var formattedJapaneseDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M/d"
        return formatter.string(from: self)
    }
}

