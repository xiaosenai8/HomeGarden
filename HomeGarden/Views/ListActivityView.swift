//
//  ListActivityView.swift
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

struct ListActivityView: View {
    
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
                FormActivityView(crop: crop)
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


//==================================================//
//  MARK: - Preview
//==================================================//

#Preview {
    // メモリ上で SwiftData を使う
    let container = try! ModelContainer(for: Crop.self, Activity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext
    
    // ダミーの作物
    let sampleCrop = Crop(orderIndex: 0, name: "トマト", icon: .tomato, color: .red)
    
    // ダミーのアクティビティを作成して紐付け
    let sampleActivity1 = Activity(date: Date(), type: .harvesting, quantity: 3, crop: sampleCrop)
    let sampleActivity2 = Activity(date: Date().addingTimeInterval(-86400 * 2), type: .watering, quantity: nil, crop: sampleCrop)
    
    // 関連付け（Crop 側に Activity を追加）
    sampleCrop.activities = [sampleActivity1, sampleActivity2]
    
    // モデルコンテキストに挿入
    context.insert(sampleCrop)
    context.insert(sampleActivity1)
    context.insert(sampleActivity2)
    
    // 表示
    return ListActivityView(crop: sampleCrop)
        .modelContainer(container)
}


