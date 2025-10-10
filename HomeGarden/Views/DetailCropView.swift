//
//  DetailCropView.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/05
//  
//

import SwiftUI
import SwiftData


//==================================================//
//  MARK: - 詳細画面
//==================================================//

struct DetailCropView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var crop: Crop
    
    var body: some View {
        ZStack {
            Text("\(crop.name)")
            Button("閉じる") {
                dismiss()
            }
        }
    }
}
