//==================================================//
//  MARK: - ActivityType.swift
//  作成者: konishi
//  作成日: 2025/10/07
//  説明  : 作物のアイコンを表す enum。表示名・システムアイコン名を管理
//==================================================//

import Foundation
import SwiftUI

//==================================================//
//  MARK: - 作業 Enum
//==================================================//
enum ActivityType: Int, Codable, CaseIterable, Identifiable {
    
    var id: Int { rawValue }
    
    case soilPreparation    = 1
    case sowingSeeds        = 2
    case plantingSeedlings  = 3
    case germination        = 4
    case flowering          = 5
    case watering           = 6
    case ThinningOut        = 7
    case topDressing        = 8
    case removeBuds         = 9
    case harvest            = 10
    case end                = 11
    case others             = 12
}

//==================================================//
//  MARK: - 作業名
//==================================================//
extension ActivityType {
    
    var activityName: String {
        switch self {
        case .soilPreparation:
            "土づくり"
        case .sowingSeeds:
            "種まき"
        case .plantingSeedlings:
            "苗植え"
        case .germination:
            "発芽"
        case .flowering:
            "開花"
        case .watering:
            "水やり"
        case .ThinningOut:
            "間引き"
        case .topDressing:
            "追肥"
        case .removeBuds:
            "芽かき"
        case .harvest:
            "収穫"
        case .end:
            "終了"
        case .others:
            "その他"
        }
        
    }
}

//==================================================//
//  MARK: - アイコン名
//==================================================//
extension ActivityType {
    
    var activityIcon: String {
        switch self {
            
        case .soilPreparation:
            "sun.min"
        case .sowingSeeds:
            "sun.min"
        case .plantingSeedlings:
            "sun.min"
        case .germination:
            "sun.min"
        case .flowering:
            "sun.min"
        case .watering:
            "sun.min"
        case .ThinningOut:
            "sun.min"
        case .topDressing:
            "sun.min"
        case .removeBuds:
            "sun.min"
        case .harvest:
            "sun.min"
        case .end:
            "sun.min"
        case .others:
            "sun.min"
        }
    }
}



