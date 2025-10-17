//
//  Util.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/17
//  
//

import Foundation

extension Date {
    var formattedJapaneseDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日"
        return formatter.string(from: self)
    }
}
