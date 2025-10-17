//
//  FormCropView.swift
//  HomeGarden
//
//  Created by konishi on 2025/10/05
//
//

import SwiftUI
import SwiftData

//==================================================//
//  MARK: - 追加画面
//==================================================//

struct FormCropView: View {
    
    //==================================================//
    //  MARK: - 変数
    //==================================================//
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var editingCrop: Crop?
    
    @State private var name: String = ""
    @State private var selectedCropIcon: CropIcon = .tomato
    @State private var selectedCropColor: CropColor = .teal
    @State private var showDeleteAlert = false
    
    //==================================================//
    //  MARK: - データ保存
    //==================================================//
    private func saveCrop() {
        if let editingCrop = editingCrop {
            // 編集モード
            editingCrop.name = name
            editingCrop.icon = selectedCropIcon
            editingCrop.color = selectedCropColor
        } else {
            // 新規作成モード
            let descriptor = FetchDescriptor<Crop>(sortBy: [SortDescriptor(\.orderIndex)])
            let crops = (try? modelContext.fetch(descriptor)) ?? []
            let newOrderIndex = (crops.map { $0.orderIndex }.max() ?? -1) + 1
            
            let newCrop = Crop(
                orderIndex: newOrderIndex,
                name: name,
                icon: selectedCropIcon,
                color: selectedCropColor
            )
            modelContext.insert(newCrop)
        }
        
        try? modelContext.save()
        dismiss()
    }
    
    //==================================================//
    //  MARK: - データ削除
    //==================================================//
    private func deleteCrop(_ crop: Crop) {
        modelContext.delete(crop)
        try? modelContext.save()
        dismiss()
    }
    
    //==================================================//
    //  MARK: - 追加画面表示
    //==================================================//
    var body: some View {
        
        NavigationView  {
            
            Form{
                
                // 名前
                Section {
                    TextField("", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .font(.largeTitle.weight(.light))
                } header: {
                    Text("野菜の名前")
                }
                
                Section {
                    // アイコン
                    Picker("アイコン", selection: $selectedCropIcon){
                        ForEach(CropIcon.allCases){icon in
                            HStack{
                                Image(systemName: icon.cropIcon)
                                Text(icon.CropIconName)
                            }
                            .tag(icon)
                        }
                    }
                    
                    // 色
                    Picker("カラー", selection: $selectedCropColor){
                        ForEach(CropColor.allCases){color in
                            Image(systemName: "circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(color.cropColor)
                                .tag(color)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                } header: {
                    Text("カスタマイズ")
                }
            }
            .navigationTitle(editingCrop == nil ? "野菜の追加" : "野菜の編集")
        }
        .onAppear {
            if let editingCrop = editingCrop {
                name = editingCrop.name
                selectedCropIcon = editingCrop.icon
                selectedCropColor = editingCrop.color
            }
        }
        
        VStack(spacing: 12) {
            // 保存
            Button{
                // 名前が入力されている場合のみアクティブにする
                if name.isEmpty || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                    return
                }else{
                    saveCrop()
                    dismiss()
                }
                
            }label: {
                Text(editingCrop == nil ? "追加" : "保存")
                    .font(.title2.weight(.medium))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle)
            .disabled(name.isEmpty || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            // キャンセル
            Button{
                dismiss()
            }label: {
                Text("キャンセル")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle)
            
            // 削除
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
                // ===== 削除確認アラート =====
                .alert("この野菜を削除しますか？", isPresented: $showDeleteAlert) {
                    Button("削除", role: .destructive) {
                        deleteCrop(editingCrop)
                    }
                    Button("キャンセル", role: .cancel) {}
                } message: {
                    Text("この操作は取り消せません。")
                }
            }
        }
        .padding()
        
    }
}

#Preview {
    FormCropView()
}
