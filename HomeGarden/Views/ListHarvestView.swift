//
//  ListHarvestView.swift
//  HomeGarden
//  
//  Created by konishi on 2025/11/20
//  
//

//==================================================//
//  MARK: - HarvestListView.swift（1画面完結版）
//==================================================//

import SwiftUI
import SwiftData

struct ListHarvestView: View {
    
    @Query(sort: [SortDescriptor(\Crop.orderIndex, order: .forward)])
    private var crops: [Crop]
    
    @Query(sort: [SortDescriptor(\Activity.date, order: .reverse)])
    private var activities: [Activity]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(crops) { crop in
                        cropSection(crop)
                    }
                }
                .padding()
            }
            .navigationTitle("収穫一覧")
        }
    }
    
    //==================================================//
    // MARK: - 作物ごとの表示ブロック
    //==================================================//
    private func cropSection(_ crop: Crop) -> some View {
        let harvested = totalHarvest(for: crop)
        
        return VStack(alignment: .leading, spacing: 12) {
            
            // タイトル行
            HStack(spacing: 16) {
                Image(crop.icon.iconName)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(color(for: crop))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(crop.name)
                        .font(.headline)
                    
                    Text("合計 \(harvested.formatted()) \(crop.unit.unitName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // 収穫履歴（その作物だけ）
//            if !history.isEmpty {
//                VStack(alignment: .leading, spacing: 6) {
//                    ForEach(history) { act in
//                        HStack {
//                            Text(act.date.formattedJapaneseDate)
//                            
//                            Spacer()
//                            
//                            Text("\(act.quantity ?? 0, specifier: "%.1f") \(crop.unit.unitName)")
//                                .foregroundColor(.secondary)
//                        }
//                        .font(.caption)
//                        .padding(.vertical, 2)
//                        
//                        Divider()
//                    }
//                }
//                .padding(.top, 4)
//            } else {
//                Text("収穫データなし")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                    .padding(.leading, 4)
//            }
            
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
    
    //==================================================//
    // MARK: - 合計収穫量
    //==================================================//
    private func totalHarvest(for crop: Crop) -> Int {
        activities
            .filter { $0.crop?.persistentModelID == crop.persistentModelID }
            .compactMap { $0.quantity }
            .reduce(0, +)
    }
    
    //==================================================//
    // MARK: - 履歴一覧
    //==================================================//
    private func harvestHistory(for crop: Crop) -> [Activity] {
        activities
            .filter { $0.crop?.persistentModelID == crop.persistentModelID }
    }
    
    //==================================================//
    // MARK: - 色
    //==================================================//
    private func color(for crop: Crop) -> Color {
        crop.color.cropColor
    }
}



#Preview {
    ListHarvestView()
        .modelContainer(PreviewData.cropsWithActivities)
}
