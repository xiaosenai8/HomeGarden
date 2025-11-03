//==================================================//
//  MARK: - ListActivityView.swift
//  作成者: konishi
//  作成日: 2025/10/05
//  説明  : 作物(Crop)に紐づく作業(Activity)一覧を表示し、追加・編集を行う画面
//==================================================//

import SwiftUI
import SwiftData

//==================================================//
//  MARK: - 作業一覧ビュー
//==================================================//
struct ListActivityView: View {
    
    //==================================================//
    //  MARK: - Environment
    //==================================================//
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    //==================================================//
    //  MARK: - 入力データ
    //==================================================//
    let crop: Crop                                 // 対象の作物
    @State private var isFormPresented = false     // フォーム表示フラグ
    @State private var editingActivity: Activity?  // 編集対象のActivity
    
    //==================================================//
    //  MARK: - Body
    //==================================================//
    var body: some View {
        VStack {
            
            headerView
            
            if !crop.activities.isEmpty {
                totalQuantityView
            }
            
            activityList
        }
        .padding()
        .sheet(isPresented: $isFormPresented) {
            if let editingActivity {
                FormActivityView(crop: crop, editingActivity: editingActivity)
            } else {
                FormActivityView(crop: crop)
            }
        }
    }
    
    //==================================================//
    //  MARK: - ヘッダー
    //==================================================//
    private var headerView: some View {
        HStack {
            Text(crop.name)
                .font(.largeTitle.weight(.semibold))
            
            Spacer()
            
            Button {
                isFormPresented = true
            } label: {
                Image(systemName: "plus.app")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.teal)
                    .font(.system(size: 20, weight: .semibold))
            }
        }
    }
    
    //==================================================//
    //  MARK: - 収量合計
    //==================================================//
    private var totalQuantityView: some View {
        let total = crop.activities.compactMap { $0.quantity }.reduce(0, +)
        return Text("収量合計：\(total)")
            .font(.headline)
            .foregroundColor(crop.color.cropColor)
            .opacity(0.9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    //==================================================//
    //  MARK: - 作業リスト
    //==================================================//
    private var activityList: some View {
        List {
            ForEach(crop.activities.sorted(by: { $0.date < $1.date })) { activity in
                ActivityRow(activity: activity, crop: crop)
                
//                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//                        Button {
//                            editingActivity = activity
//                            isFormPresented = true
//                        } label: {
//                            Label("編集", systemImage: "pencil")
//                        }
//                        .tint(.blue)
//                    }
            }
            .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
    }
}

//==================================================//
//  MARK: - Activity 行ビュー
//==================================================//
private struct ActivityRow: View {
    let activity: Activity
    let crop: Crop
    
    var body: some View {
        HStack {
            iconView
            contentView
        }

    }
    
    private var iconView: some View {
        Image(systemName: activity.activity.activityIcon)
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
    }
    
    private var contentView: some View {
        Rectangle()
            .fill(.white)
            .frame(width: 250, height: 60)
            .overlay(
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.date.formattedJapaneseDate)
                        .foregroundColor(.gray)
                        .font(.caption)
                    
                    Text(activity.activity.activityName)
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
    }
}

//==================================================//
//  MARK: - Preview
//==================================================//
#Preview {
    let container = try! ModelContainer(
        for: Crop.self, Activity.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    
    let sampleCrop = Crop(orderIndex: 0, name: "トマト", icon: .tomato, color: .red)
    let sampleActivity1 = Activity(date: Date(), activity: .watering, quantity: 3)
    let sampleActivity2 = Activity(date: Date().addingTimeInterval(-86400 * 2), activity: .watering, quantity: nil)
    sampleCrop.activities = [sampleActivity1, sampleActivity2]
    
    context.insert(sampleCrop)
    context.insert(sampleActivity1)
    context.insert(sampleActivity2)
    
    return ListActivityView(crop: sampleCrop)
        .modelContainer(container)
}

