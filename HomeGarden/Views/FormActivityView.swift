//==================================================//
//  MARK: - FormActivityView.swift
//  作成者: konishi
//  作成日: 2025/10/10
//  説明  : 作物の作業（Activity）を追加・編集・削除するフォーム画面
//==================================================//

import SwiftUI
import SwiftData

//==================================================//
//  MARK: - 作業フォームビュー
//==================================================//
struct FormActivityView: View {
    
    //==================================================//
    //  MARK: - Environment
    //==================================================//
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    //==================================================//
    //  MARK: - 入力データ
    //==================================================//
    
    let crop: Crop
    var editingActivity: Activity? = nil
    
    @State private var selectedType: ActivityType = .watering   // 作業タイプ
    @State private var selectedDate = Date()                    // 作業日
    @State private var quantity: Int? = nil                     // 数量
    @State private var quantityString: String = ""              // 数量入力文字列
    @State private var comment: String = ""                     // 作業メモ
    @State private var showDeleteAlert = false                  // 削除アラート表示フラグ
    
    //==================================================//
    //  MARK: - Body
    //==================================================//
    
    var body: some View {
        NavigationView {
            Form {
                
                // 作業日
                Section("作業日") {
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accentColor(.teal)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                }
                
                // 作業タイプ
                Section("作業タイプ") {
                    Picker("作業", selection: $selectedType) {
                        ForEach(ActivityType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // 数量
                Section("数量") {
                    TextField(
                        "数量を入力",
                        text: Binding(
                            get: { quantityString },
                            set: { newValue in
                                quantityString = newValue
                                quantity = Int(newValue)
                            }
                        )
                    )
                    .keyboardType(.numberPad)
                }
                
                // 作業メモ
                Section("作業メモ") {
                    TextField("", text: $comment)
                        .textFieldStyle(.roundedBorder)
                        .font(.largeTitle.weight(.light))
                }
            }
            .navigationTitle(editingActivity == nil ? "作業追加" : "作業保存")
        }
        
        // ボタンエリア
        VStack(spacing: 12) {
            
            // 追加 / 保存
            Button {
                saveActivity()
                dismiss()
            } label: {
                Text(editingActivity == nil ? "追加" : "保存")
                    .font(.title2.weight(.medium))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle)
            
            // キャンセル
            Button {
                dismiss()
            } label: {
                Text("キャンセル")
                    .font(.title2.weight(.medium))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle)
            
            // 削除（編集モード時のみ表示）
            if let editingActivity = editingActivity {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Text("削除")
                        .font(.title2.weight(.medium))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .buttonBorderShape(.roundedRectangle)
                .tint(.red)
                .alert("削除の確認", isPresented: $showDeleteAlert) {
                    Button("削除", role: .destructive) {
                        deleteActivity(editingActivity)
                        dismiss()
                    }
                    Button("キャンセル", role: .cancel) { }
                } message: {
                    Text("この作業を削除してもよろしいですか？")
                }
            }
        }
        .padding()
        .onAppear {
            initializeEditingActivity()
        }
    }
    
    //==================================================//
    //  MARK: - 編集データ初期化
    //==================================================//
    
    /// 編集モード時に既存データをフォームに反映
    private func initializeEditingActivity() {
        guard let editingActivity = editingActivity else { return }
        selectedType = editingActivity.type
        selectedDate = editingActivity.date
        quantity = editingActivity.quantity
        quantityString = editingActivity.quantity.map { String($0) } ?? ""
        comment = editingActivity.comment ?? ""
    }
    
    //==================================================//
    //  MARK: - 保存処理
    //==================================================//
    
    /// 作業の保存・更新処理
    private func saveActivity() {
        if let editingActivity = editingActivity {
            // 編集モード: 既存オブジェクトを更新
            editingActivity.type = selectedType
            editingActivity.date = selectedDate
            editingActivity.quantity = quantity
            editingActivity.comment = comment
        } else {
            // 新規作成モード
            let newActivity = Activity(
                date: selectedDate,
                type: selectedType,
                quantity: quantity,
                comment: comment,
                crop: crop
            )
            modelContext.insert(newActivity)
            crop.activities.append(newActivity)
        }
        try? modelContext.save()
    }
    
    //==================================================//
    //  MARK: - 削除処理
    //==================================================//
    private func deleteActivity(_ activity: Activity) {
        // Crop 側の activities 配列から削除
        if let index = crop.activities.firstIndex(where: { $0.id == activity.id }) {
            crop.activities.remove(at: index)
        }
        // モデルコンテキストから削除
        modelContext.delete(activity)
        try? modelContext.save()
        dismiss()
    }
}

//==================================================//
//  MARK: - Preview
//==================================================//
#Preview {
    let sampleCrop = Crop(orderIndex: 0, name: "トマト", icon: .tomato, color: .red)
    FormActivityView(crop: sampleCrop)
}

