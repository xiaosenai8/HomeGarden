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
        ZStack(alignment: .bottomTrailing) {
            VStack {
                headerView
                
                if !crop.activities.isEmpty {
                    totalQuantityView
                }
                
                activityList
            }
            .padding(.horizontal)
            
            Button {
                isFormPresented = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(.teal))
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
            }
            .padding()
            .accessibilityLabel("新しい作業を追加")
        }
        //        .sheet(isPresented: $isFormPresented) {
        //            if let editingActivity {
        //                FormActivityView(crop: crop, editingActivity: editingActivity)
        //            } else {
        //                FormActivityView(crop: crop)
        //            }
        //        }
        .sheet(isPresented: $isFormPresented) {
            FormActivityView(crop: crop)
        }
        .sheet(item: $editingActivity) { activity in
            FormActivityView(crop: crop, editingActivity: activity)
        }
        
    }
    
    //==================================================//
    //  MARK: - ヘッダー
    //==================================================//
    private var headerView: some View {
        HStack {
            Text(crop.name)
                .foregroundColor(Color("FontColor"))
                .font(.largeTitle.weight(.semibold))
            
            Spacer()
            
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
            .font(.largeTitle.weight(.semibold))
    }
    
    //==================================================//
    //  MARK: - 作業リスト
    //==================================================//
    private var activityList: some View {
        List {
            ForEach(crop.activities.sorted(by: { $0.date < $1.date })) { activity in
                ActivityRow(activity: activity, crop: crop) {
                    editingActivity = activity
                }
                .listRowSeparator(.hidden)
            }
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
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            dateView
            iconView
            contentView
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
    }
    private var dateView: some View {
        Text(activity.date.formattedJapaneseDate)
    }
    
    private var iconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(crop.color.cropColor)
                .frame(width: 44, height: 44)
                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
            
            Image(systemName: activity.activity.activityIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(.white)
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 4) {
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
        .padding(10)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        .frame(maxWidth: .infinity, alignment: .leading)
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

