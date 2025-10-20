//==================================================//
//  MARK: - FormCropView.swift
//  作成者: konishi
//  作成日: 2025/10/05
//  説明  : 作物（Crop）の追加・編集・削除を行うフォーム画面
//==================================================//

import SwiftUI
import SwiftData

//==================================================//
//  MARK: - 作物フォームビュー
//==================================================//
struct FormCropView: View {
    
    //==================================================//
    //  MARK: - Environment
    //==================================================//
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    //==================================================//
    //  MARK: - 入力データ
    //==================================================//
    var editingCrop: Crop?   // 編集対象のCrop
    
    @State private var cropName: String = ""                      // 野菜の名前
    @State private var selectedIcon: CropIcon = .tomato           // アイコン選択
    @State private var selectedColor: CropColor = .teal           // カラー選択
    @State private var showDeleteAlert: Bool = false             // 削除アラート表示
    
    //==================================================//
    //  MARK: - Body
    //==================================================//
    var body: some View {
        NavigationView {
            Form {
                
                // 名前入力
                Section(header: Text("野菜の名前")) {
                    TextField("", text: $cropName)
                        .textFieldStyle(.roundedBorder)
                        .font(.largeTitle.weight(.light))
                }
                
                // カスタマイズ
                Section(header: Text("カスタマイズ")) {
                    // アイコン
                    Picker("アイコン", selection: $selectedIcon) {
                        ForEach(CropIcon.allCases) { icon in
                            HStack {
                                Image(icon.iconName)
                            }
                            .tag(icon)
                        }
                    }
                    
                    // カラー
                    Picker("カラー", selection: $selectedColor) {
                        ForEach(CropColor.allCases) { color in
                            Image(systemName: "circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(color.cropColor)
                                .tag(color)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle(editingCrop == nil ? "野菜の追加" : "野菜の編集")
        }
        .onAppear {
            initializeForm()
        }
        
        // ボタンエリア
        VStack(spacing: 12) {
            
            // 保存 / 追加
            Button {
                guard !cropName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                saveCrop()
            } label: {
                Text(editingCrop == nil ? "追加" : "保存")
                    .font(.title2.weight(.medium))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle)
            .disabled(cropName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            // キャンセル
            Button {
                dismiss()
            } label: {
                Text("キャンセル")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle)
            
            // 削除ボタン（編集モードのみ表示）
            if let editingCrop = editingCrop {
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
                .alert("この野菜を削除しますか？", isPresented: $showDeleteAlert) {
                    Button("削除", role: .destructive) { deleteCrop(editingCrop) }
                    Button("キャンセル", role: .cancel) {}
                } message: {
                    Text("この操作は取り消せません。")
                }
            }
        }
        .padding()
    }
    
    //==================================================//
    //  MARK: - 編集データ初期化
    //==================================================//
    private func initializeForm() {
        guard let editingCrop = editingCrop else { return }
        cropName = editingCrop.name
        selectedIcon = editingCrop.icon
        selectedColor = editingCrop.color
    }
    
    //==================================================//
    //  MARK: - 保存処理
    //==================================================//
    private func saveCrop() {
        if let editingCrop = editingCrop {
            // 編集モード
            editingCrop.name = cropName
            editingCrop.icon = selectedIcon
            editingCrop.color = selectedColor
        } else {
            // 新規作成モード
            let descriptor = FetchDescriptor<Crop>(sortBy: [SortDescriptor(\.orderIndex)])
            let crops = (try? modelContext.fetch(descriptor)) ?? []
            let newOrderIndex = (crops.map { $0.orderIndex }.max() ?? -1) + 1
            
            let newCrop = Crop(
                orderIndex: newOrderIndex,
                name: cropName,
                icon: selectedIcon,
                color: selectedColor
            )
            modelContext.insert(newCrop)
        }
        
        try? modelContext.save()
        dismiss()
    }
    
    //==================================================//
    //  MARK: - 削除処理
    //==================================================//
    private func deleteCrop(_ crop: Crop) {
        modelContext.delete(crop)
        try? modelContext.save()
        dismiss()
    }
}

//==================================================//
//  MARK: - Preview
//==================================================//
#Preview {
    FormCropView()
}

