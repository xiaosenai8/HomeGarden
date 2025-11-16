//
//  DebugDataView.swift
//  HomeGarden
//
//  Created by konishi on 2025/11/16
//  説明  : SwiftData のデバッグ用データ確認画面
//

import SwiftUI
import SwiftData

//==================================================//
// MARK: - DebugDataView
//==================================================//

struct DebugDataView: View {
    
    //==================================================//
    // MARK: - Environment / Query
    //==================================================//
    
    @Environment(\.modelContext) private var modelContext
    
    /// 全作物（並び順で取得）
    @Query(sort: [SortDescriptor(\Crop.orderIndex)])
    private var crops: [Crop]
    
    /// 全アクティビティ（作物無しも含む）
    @Query(sort: [SortDescriptor(\Activity.date, order: .reverse)])
    private var activities: [Activity]
    
    
    //==================================================//
    // MARK: - State
    //==================================================//
    
    /// アラート表示制御
    @State private var showDeleteAlert = false
    
    /// 削除対象（crop か activity を保持）
    @State private var targetCrop: Crop? = nil
    @State private var targetActivity: Activity? = nil
    
    /// 日付フォーマッタ
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df
    }()
    
    
    //==================================================//
    // MARK: - Body
    //==================================================//
    
    var body: some View {
        NavigationStack {
            List {
                cropListSection
                orphanActivitySection
            }
            .navigationTitle("データ確認")
            .alert("削除しますか？", isPresented: $showDeleteAlert, actions: deleteAlertActions, message: deleteAlertMessage)
        }
    }
}


//==================================================//
// MARK: - Section: 作物一覧
//==================================================//

extension DebugDataView {
    
    /// 作物ごとの情報を並べるセクション
    private var cropListSection: some View {
        ForEach(crops) { crop in
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    
                    cropHeader(crop)
                    
                    if crop.activities.isEmpty {
                        Text("アクティビティなし")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(crop.activities.sorted { $0.date < $1.date }) { act in
                                activityRow(act)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    /// 作物の上部ヘッダー部分
    private func cropHeader(_ crop: Crop) -> some View {
        HStack(spacing: 12) {
            Image(crop.icon.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(crop.displayColor)
                .padding(16)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(crop.name)
                    .font(.headline)
                
                if crop.isArchived {
                    Text("アーカイブ")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("アクティビティ: \(crop.activities.count) 件")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}


//==================================================//
// MARK: - Activity 行ビュー
//==================================================//

extension DebugDataView {
    
    /// アクティビティ1件の表示
    private func activityRow(_ act: Activity) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Text(dateFormatter.string(from: act.date))
                .font(.subheadline)
            
            Text("作業: \(act.activity.activityName)")
                .font(.footnote)
            
            if let q = act.quantity {
                Text("数量: \(q)")
                    .font(.footnote)
            }
            
            if let c = act.comment, !c.isEmpty {
                Text("メモ: \(c)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .contextMenu {
            Button("削除", role: .destructive) {
                prepareDelete(activity: act)
            }
        }
    }
}


//==================================================//
// MARK: - Section: 孤立アクティビティ
//==================================================//

extension DebugDataView {
    
    /// Crop に紐づかないアクティビティ
    private var orphanActivities: [Activity] {
        activities.filter { $0.crop == nil }
    }
    
    /// 孤立アクティビティ表示セクション
    private var orphanActivitySection: some View {
        Group {
            if !orphanActivities.isEmpty {
                Section("⚠️ 孤立アクティビティ（未紐付け）") {
                    ForEach(orphanActivities) { act in
                        activityRow(act)
                    }
                }
            }
        }
    }
}


//==================================================//
// MARK: - 削除処理 / アラート
//==================================================//

extension DebugDataView {
    
    /// 削除対象をセットしてアラート表示
    private func prepareDelete(crop: Crop? = nil, activity: Activity? = nil) {
        targetCrop = crop
        targetActivity = activity
        showDeleteAlert = true
    }
    
    /// アラートのアクション
    private func deleteAlertActions() -> some View {
        Group {
            Button("キャンセル", role: .cancel) {}
            Button("削除", role: .destructive) { performDelete() }
        }
    }
    
    /// アラートのメッセージ
    private func deleteAlertMessage() -> some View {
        Group {
            if let crop = targetCrop {
                Text("「\(crop.name)」と、その全アクティビティを削除します。")
            } else {
                Text("このアクティビティを削除します。")
            }
        }
    }
    
    /// 実際の削除を実行
    private func performDelete() {
        if let crop = targetCrop {
            modelContext.delete(crop)
        }
        if let act = targetActivity {
            modelContext.delete(act)
        }
        try? modelContext.save()
    }
}


//==================================================//
// MARK: - Preview
//==================================================//

#Preview {
    DebugDataView()
        .modelContainer(PreviewData.cropsWithActivities)
}

