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
    
    @State private var navigationPath = NavigationPath()
    @State private var cropName: String = ""
    @State private var selectedIcon: CropIcon = .tomato
    @State private var selectedColor: CropColor = .green
    @State private var showDeleteAlert: Bool = false
    @State private var customColor: Color = .black
    @State private var showColorPicker = false
    @State private var showInlineColorPicker = false
    
    //==================================================//
    //  MARK: - Body
    //==================================================//
    var body: some View {
        NavigationStack(path: $navigationPath) {
            // フォーム
            Form {
                // 名前入力
                Section(header: Text("野菜の名前")) {
                    TextField("", text: $cropName)
                        .textFieldStyle(.roundedBorder)
                        .font(.largeTitle.weight(.light))
                }
                
                // アイコン選択
                Section(header: Text("アイコン")) {
                    NavigationLink {
                        PickerCropIconView(selectedIcon: $selectedIcon)
                    } label: {
                        HStack {
                            Image(selectedIcon.iconName)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // カラー選択
                Section(header: Text("カラー")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            
                            ForEach(CropColor.allCases) { color in
                                if color != .custom {
                                    Circle()
                                        .fill(color.cropColor)
                                        .frame(width: 34, height: 34)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.blue, lineWidth: selectedColor == color ? 3 : 0)
                                        )
                                        .onTapGesture {
                                            selectedColor = color
                                        }
                                }
                            }
                            
                            ColorPicker("", selection: $customColor)
                                .labelsHidden()
                                .frame(width: 40, height: 40)
                                .onChange(of: customColor) { oldValue, newValue in
                                    selectedColor = .custom
                                }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle(editingCrop == nil ? "野菜の追加" : "野菜の編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        // ボタン
        VStack(spacing: 12) {
            
            Button {
                saveCrop()
            } label: {
                Text(editingCrop == nil ? "追加" : "保存")
                    .font(.title2.weight(.medium))
                    .frame(maxWidth: .infinity)
            }
            .disabled(cropName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle)
            
            //            Button {
            //                dismiss()
            //            } label: {
            //                Text("キャンセル")
            //                    .font(.title2.weight(.medium))
            //                    .frame(maxWidth: .infinity)
            //            }
            //            .buttonStyle(.bordered)
            //            .controlSize(.large)
            //            .buttonBorderShape(.roundedRectangle)
            //
            //            if let editingCrop = editingCrop {
            //                Button(role: .destructive) {
            //                    showDeleteAlert = true
            //                } label: {
            //                    Text("削除")
            //                        .font(.title2.weight(.medium))
            //                        .frame(maxWidth: .infinity)
            //                }
            //                .buttonStyle(.borderedProminent)
            //                .controlSize(.large)
            //                .buttonBorderShape(.roundedRectangle)
            //                .tint(.red)
            //                .alert("この野菜を削除しますか？", isPresented: $showDeleteAlert) {
            //                    Button("削除", role: .destructive) { deleteCrop(editingCrop) }
            //                    Button("キャンセル", role: .cancel) {}
            //                } message: {
            //                    Text("この操作は取り消せません。")
            //                }
            //            }
        }
        .padding()
        .onAppear(perform: initializeForm)
        
        
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
        // 編集中か新規作成かを判定
        if let editingCrop = editingCrop {
            // 既存作物の更新
            editingCrop.name = cropName
            editingCrop.icon = selectedIcon
            editingCrop.color = selectedColor
            
            // カスタム色選択時は Hex 保存
            if selectedColor == .custom {
                editingCrop.customColorHex = customColor.hexString
            } else {
                editingCrop.customColorHex = nil
            }
            
        } else {
            // 新規作成時：次の orderIndex を決定
            let descriptor = FetchDescriptor<Crop>(sortBy: [SortDescriptor(\.orderIndex)])
            let crops = (try? modelContext.fetch(descriptor)) ?? []
            let newOrderIndex = (crops.map { $0.orderIndex }.max() ?? -1) + 1
            
            // 新しい Crop インスタンスを作成
            let newCrop = Crop(
                orderIndex: newOrderIndex,
                name: cropName,
                icon: selectedIcon,
                color: selectedColor
            )
            
            // カスタム色選択時は Hex 保存
            if selectedColor == .custom {
                newCrop.customColorHex = customColor.hexString
            }
            
            // モデルに挿入
            modelContext.insert(newCrop)
        }
        
        // 保存処理
        do {
            try modelContext.save()
            print("保存成功: \(cropName)")
        } catch {
            print("保存失敗: \(error)")
        }
        
        // 画面を閉じる
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

extension View {
    func colorPickerSheet(isPresented: Binding<Bool>, color: Binding<Color>) -> some View {
        self.sheet(isPresented: isPresented) {
            VStack {
                Text("色を選択")
                    .font(.headline)
                ColorPicker("", selection: color)
                    .labelsHidden()
                    .padding()
                Spacer()
            }
            .presentationDetents([.height(200)])
        }
    }
}

//==================================================//
//  MARK: - Preview
//==================================================//
#Preview {
    FormCropView()
}


