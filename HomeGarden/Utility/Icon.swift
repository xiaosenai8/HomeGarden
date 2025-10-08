//
//  Icon.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/07
//  
//

import Foundation

enum Icon: Int,Codable,CaseIterable,Identifiable{
    var id: Int{
        rawValue
    }
    
    case tomato      = 1
    case eggplant    = 2
    case cucumber    = 3

}

extension Icon{
    var name: String{
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

extension Icon{
    var iconType: String{
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
