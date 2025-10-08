//
//  ContentView.swift
//  Watchlist
//
//  Created by 小森愛 on 2025/10/04.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            ListCropView()
                .tabItem {
                    Label("一覧", systemImage: "list.bullet")
                }
            SettingView()
                .tabItem {
                    Text("設定")
                    Image(systemName: "gearshape")
                }
        }
        .accentColor(.teal)
    }
}

#Preview("Sample List") {
    ContentView()
        .modelContainer(Crop.preview)
}

#Preview("Empty List") {
    ContentView()
        .modelContainer(for: Crop.self, inMemory: true)
}
