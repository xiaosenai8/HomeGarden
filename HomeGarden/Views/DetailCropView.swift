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
    @Environment(\.modelContext) var modelContext
    let crop: Crop
    
    @Query private var activities: [Activity]
    
    @State private var isAddingActivity = false
    
    init(crop: Crop) {
        self.crop = crop
    }
    
    var body: some View {
        VStack {
            Text(crop.name)
                .font(.largeTitle.bold())
            
            List {
                ForEach(activities) { activity in
                    HStack {
                        Text(activity.type.displayName)
                        Spacer()
                        if let q = activity.quantity {
                            Text("\(q)")
                        }
                        Text(activity.date, style: .date)
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
                .onDelete(perform: deleteActivity)
            }
            
            Button("作業追加") {
                isAddingActivity = true
            }
            .sheet(isPresented: $isAddingActivity) {
                NewActivityFormView(crop: crop)
            }
        }
        .padding()
    }
    
    private func deleteActivity(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(activities[index])
        }
        try? modelContext.save()
    }
}
