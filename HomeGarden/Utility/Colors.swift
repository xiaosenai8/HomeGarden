//
//  Color.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/08
//  
//

import Foundation

enum Color: Int,Codable,CaseIterable,Identifiable{
    var id: Int{
        rawValue
    }

        case red
        case green
        case blue
    
}

extension Color{
    var name: String{
        switch self {
            
        case .red:
            "赤"
        case .green:
            "緑"
        case .blue:
            "青"
        }
    }
}

extension Color{
    var colorType: String{
        switch self {
            
        case .red:
            "sun.min"
        case .green:
            "moon"
        case .blue:
            "cloud"
        }
    }
}
