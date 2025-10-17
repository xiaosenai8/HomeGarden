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
    @State private var isSheetPresented = false
    @State private var isEditMode = false
    @State private var editingActivity: Activity? = nil
    
    init(crop: Crop) {
        self.crop = crop
    }
    
    var body: some View {
        VStack {
            HStack {
                
                Text(crop.name)
                    .font(.largeTitle.weight(.semibold))
                
                Spacer()
                
                HStack(spacing: 12) {
                    // ＋ ボタン：追加
                    Button {
                        isSheetPresented = true
                    } label: {
                        Image(systemName: "plus.app")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.teal)
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
            }
            
            if !crop.activities.isEmpty {
                let totalQuantity = crop.activities.compactMap { $0.quantity }.reduce(0, +)
                Text("収量合計：\(totalQuantity)")
                    .font(.headline)
                    .foregroundColor(crop.color.cropColor)
                    .opacity(0.9)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            
            List{
                ForEach(crop.activities.sorted(by: { $0.date < $1.date })) { activity in
                    HStack{
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .stroke(crop.color.cropColor, lineWidth: 2)
                                    .opacity(0.4)
                                    .frame(width: 60, height: 60)
                            )
                            .padding(.leading, 5)
                            .padding(.trailing, 20)
                        
                        Rectangle()
                            .fill(.white)
                            .frame(width: 250, height: 60)
                            .overlay(
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(activity.date.formattedJapaneseDate)
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                    
                                    Text(activity.type.displayName)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    if let quantity = activity.quantity {
                                        Text("数量: \(quantity)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    if let comment = activity.comment, !comment.isEmpty {
                                        Text(comment)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 8)
                            )
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    // 編集用の Activity をセットしてシート表示
                                    editingActivity = activity
                                    isSheetPresented = true
                                } label: {
                                    Label("編集", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            .sheet(isPresented: $isSheetPresented) {
                if let editingActivity {
                    FormActivityView(crop: crop, editingActivity: editingActivity)
                } else {
                    FormActivityView(crop: crop)
                }
            }
        }
        .padding()
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


