//
//  NewCropFormView.swift
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

struct NewCropFormView: View {
    
    //==================================================//
    //  MARK: - 変数
    //==================================================//
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var selsctedCropIcon: CropIcon = .tomato
    @State private var selectedCropColor: CropColor = .teal
    
    //==================================================//
    //  MARK: - データ追加
    //==================================================//
    private func addNewCrop() {
        
        // SwiftData から既存の Crop を取得して、orderIndex でソート
        let descriptor = FetchDescriptor<Crop>(sortBy: [SortDescriptor(\.orderIndex)])
        let crops = (try? modelContext.fetch(descriptor)) ?? []
        
        // 現在の最大 orderIndex を取得し、新しい Crop の orderIndex を決定
        // crops が空の場合は -1 からスタートするので最初の orderIndex は 0 になる
        let newOrderIndex = (crops.map { $0.orderIndex }.max() ?? -1) + 1
        
        // 新しい Crop を作成し、決めた orderIndex をセット
        let newCrop = Crop(orderIndex: newOrderIndex, name: name, icon: selsctedCropIcon, color: selectedCropColor)
        
        // モデルコンテキストに挿入（保存待ち状態になる）
        modelContext.insert(newCrop)
        
        // データベースに保存
        try? modelContext.save()
        
        // モーダルや画面を閉じる
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
                    Picker("アイコン", selection: $selsctedCropIcon){
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
                .navigationTitle("野菜の追加")
            }
            
            // 保存
            Button{
                // 名前が入力されている場合のみアクティブにする
                if name.isEmpty || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                    return
                }else{
                    addNewCrop()
                    dismiss()
                }
                
            }label: {
                Text("追加")
                    .font(.title2.weight(.medium))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)
            .buttonBorderShape(.roundedRectangle)
            .disabled(name.isEmpty || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            // キャンセル
            Button{
                dismiss()
            }label: {
                Text("キャンセル")
                    .frame(maxWidth: .infinity)
            }
            
        }
    }
    
    #Preview {
        NewCropFormView()
    }
