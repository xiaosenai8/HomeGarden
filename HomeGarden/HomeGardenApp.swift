//
//  HomeGardenApp.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/05
//  
//

import SwiftUI
import SwiftData

@main
struct HomeGardenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Crop.self)
        }
    }
}
