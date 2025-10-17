//
//  FormActivityView.swift
//  HomeGarden
//
//  Created by konishi on 2025/10/10
//
//

import SwiftUI
import SwiftData

struct FormActivityView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    let crop: Crop
    var editingActivity: Activity? = nil
    
    @State private var selectedType: ActivityType = .watering  // 作業タイプ
    @State private var selectedDate = Date()                   // 作業日
    @State private var quantity: Int? = nil                    // 数量
    @State private var quantityString: String = ""             // 数量入力用文字列
    @State private var comment: String = ""                    // 作業メモ
    @State private var showDeleteAlert = false

    
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
                
                Section("作業タイプ") {
                    Picker("作業", selection: $selectedType) {
                        ForEach(ActivityType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("数量（任意）") {
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
            .navigationTitle("作業追加")
        }
        // ===== ボタンエリア =====
        VStack(spacing: 12) {
            Button {
                saveActivity()
                dismiss()
            } label: {
                Text("追加")
                    .font(.title2.weight(.medium))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle)
            
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
            
            // ===== 削除ボタン追加 =====
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
            if let editingActivity = editingActivity {
                // 編集時：既存データを反映
                selectedType = editingActivity.type
                selectedDate = editingActivity.date
                quantity = editingActivity.quantity
                quantityString = editingActivity.quantity.map { String($0) } ?? ""
                comment = editingActivity.comment ?? ""
            }
        }
    }
    
    // ===== 保存処理 =====
    private func saveActivity() {
        if let editingActivity = editingActivity {
            // 編集モード
            editingActivity.type = selectedType
            editingActivity.date = selectedDate
            editingActivity.quantity = quantity
            editingActivity.comment = comment
        } else {
            // 新規追加モード
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
    
    // ===== 削除処理 =====
    private func deleteActivity(_ activity: Activity) {
        // Crop側のactivitiesから削除
        if let index = crop.activities.firstIndex(where: { $0.id == activity.id }) {
            crop.activities.remove(at: index)
        }
        
        // モデルコンテキストから削除
        modelContext.delete(activity)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    let sampleCrop = Crop(orderIndex: 0, name: "トマト", icon: .tomato, color: .red)
    FormActivityView(crop: sampleCrop)
}
