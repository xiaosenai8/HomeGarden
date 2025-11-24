//==================================================//
//  MARK: - ListActivityView.swift
//  作成者: konishi
//  作成日: 2025/10/05
//  説明  : 作物(Crop)に紐づく作業(Activity)一覧を表示し、追加・編集を行う画面
//==================================================//

//==================================================//
//  MARK: - ListActivityView.swift
//==================================================//

import SwiftUI
import SwiftData

struct ListActivityView: View {
    
    //==================================================//
    //  MARK: - Environment
    //==================================================//
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    //==================================================//
    //  MARK: - Inputs
    //==================================================//
    let crop: Crop
    @State private var isFormPresented = false
    @State private var editingActivity: Activity?
    
    // 設定シート&確認アラート
    @State private var showSettingsSheet = false
    @State private var showArchiveAlert = false
    @State private var showDeleteAlert = false
    @State private var isEditCropPresented = false
    
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
            
            // +ボタン
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
        }
        
        // 作業追加フォーム（新規）
        .sheet(isPresented: $isFormPresented) {
            FormActivityView(crop: crop)
        }
        
        // 作業編集フォーム（編集）
        .sheet(item: $editingActivity) { activity in
            FormActivityView(crop: crop, editingActivity: activity)
        }
        
        .sheet(isPresented: $isEditCropPresented) {
            FormCropView(editingCrop: crop)
        }
        
        //==================================================//
        //  設定シート（下から出る）
        //==================================================//
        .sheet(isPresented: $showSettingsSheet) {
            VStack(spacing: 0) {
                Text("設定")
                    .font(.headline)
                    .padding(.top, 20)
                
                List {
                    Button {
                        showSettingsSheet = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            isEditCropPresented = true
                        }
                    } label: {
                        Text("編集")
                    }
                    
                    Button(role: .destructive) {
                        showSettingsSheet = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            showDeleteAlert = true
                        }
                    } label: {
                        Text("削除")
                    }
                }
                .listStyle(.insetGrouped)
                
                Button("キャンセル") {
                    showSettingsSheet = false
                }
                .padding()
            }
            .presentationDetents([.medium])   // 下から中サイズ
            .presentationDragIndicator(.visible)
        }
        
        //==================================================//
        //  削除確認アラート
        //==================================================//
        .alert("削除しますか？", isPresented: $showDeleteAlert) {
            Button("キャンセル", role: .cancel) { }
            Button("OK", role: .destructive) {
                deleteCrop()
            }
        } message: {
            Text("\(crop.name) を完全に削除します。")
        }
    }
    
    //==================================================//
    //  MARK: - Header（設定ボタン付き）
    //==================================================//
    private var headerView: some View {
        HStack {
            Text(crop.name)
                .foregroundColor(Color("FontColor"))
                .font(.largeTitle.weight(.semibold))
            
            Spacer()
            
            Button {
                showSettingsSheet = true
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
    }
    
    //==================================================//
    //  MARK: - 収量合計
    //==================================================//
    private var totalQuantityView: some View {
        let total = crop.activities.compactMap { $0.quantity }.reduce(0, +)
        return Text("収量合計：\(total)\(crop.unit.unitName)")
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
                ActivityRow(activity: activity, crop: crop) {
                    editingActivity = activity
                }
                .listRowSeparator(.hidden)
            }
        }
        .scrollContentBackground(.hidden)
    }
    
    //==================================================//
    //  MARK: - アーカイブ処理
    //==================================================//
    private func archiveCrop() {
        crop.isArchived = true
        try? modelContext.save()
        dismiss()
    }
    
    //==================================================//
    //  MARK: - 削除処理
    //==================================================//
    private func deleteCrop() {
        modelContext.delete(crop)
        try? modelContext.save()
        dismiss()
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
        VStack {
            HStack {
                    Text(activity.date.formattedJapaneseDate)
                    Spacer()
            }
            HStack {
                
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.activity.activityName)
                        .font(.headline)
                    
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
            .contentShape(Rectangle())
            .onTapGesture {
                onTap?()
            }
        }
    }
}

//==================================================//
//  MARK: - Preview
//==================================================//
#Preview {
    let data = PreviewData.listActivityView
    return ListActivityView(crop: data.crop)
        .modelContainer(data.container)
}


