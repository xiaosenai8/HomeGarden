//
//  CropIcon.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/07
//  
//

import Foundation
import SwiftUI

//==================================================//
//  MARK: - 構造体
//==================================================//
enum CropIcon: Int,Codable,CaseIterable,Identifiable{
    var id: Int{
        rawValue
    }
    
    case tomato      = 1
    case eggplant    = 2
    case cucumber    = 3

}

extension CropIcon{
    var CropIconName: String{
        switch self {
            
        case .tomato:
            "トマト"
        case .eggplant:
            "ナス"
        case .cucumber:
            "きゅうり"
        }
    }
}

extension CropIcon{
    var cropIcon: String{
        switch self {
            
        case .tomato:
            "sun.min"
        case .eggplant:
            "moon"
        case .cucumber:
            "cloud"
        }
    }
}
