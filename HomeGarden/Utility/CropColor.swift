//
//  CropColor.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/08
//  
//

import Foundation
import SwiftUI

//==================================================//
//  MARK: - 構造体
//==================================================//
enum CropColor: Int,Codable,CaseIterable,Identifiable{
    var id: Int{
        rawValue
    }
    
    case teal      = 1
    case green     = 2
    case red       = 3
    case brown     = 4
    case orange    = 5
    case yellow    = 6
}

extension CropColor{
    var cropColor: Color{
        switch self {

        case .teal:
            .teal
        case .green:
            .green
        case .red:
            .red
        case .brown:
            .brown
        case .orange:
            .orange
        case .yellow:
            .yellow
        }
    }
}
