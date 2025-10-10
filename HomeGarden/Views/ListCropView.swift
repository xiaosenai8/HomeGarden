//
//  ListCropView.swift
//  HomeGarden
//
//  Created by konishi on 2025/10/07
//

import SwiftUI
import SwiftData

//==================================================//
//  MARK: - 一覧画面
//==================================================//

struct ListCropView: View {
    
    //==================================================//
    //  MARK: - 変数
    //==================================================//

    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Crop.orderIndex)]) private var crops: [Crop]
    
    @State private var isSheetPresented = false
    @State private var isEditMode = false
    @State private var selectedCrop: Crop?
    
    //==================================================//
    //  MARK: - 一覧画面表示
    //==================================================//
    
    var body: some View {
        
        // ナビゲーション
        NavigationStack {
            VStack {
                
                // ヘッダー
                HeaderView(isSheetPresented: $isSheetPresented, isEditMode: $isEditMode)
                
                // リスト
                List {
                    ForEach(crops) { crop in
                        
                        //　詳細画面表示ボタン
                        Button {
                            
                            // エディットモードの時は抜ける
                            guard !isEditMode else { return }
                            
                            // 選択した作物を格納
                            selectedCrop = crop
                            
                        } label: {
                            
                            // 行の表示
                            CropRowView(isEditMode: $isEditMode, crop: crop)
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                        .listRowInsets(.init(top: 10, leading: 20, bottom: 20, trailing: 10))
                        .listRowSeparator(.hidden)
                        .cornerRadius(10)
                    }
                    // 編集モードの設定
                    .onDelete(perform: deleteCrop)
                    .onMove(perform: moveCrop)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .environment(\.editMode, .constant(isEditMode ? .active : .inactive))
            }
            .sheet(isPresented: $isSheetPresented) {
                
                // 追加画面の表示
                NewCropFormView()
            }
            
            .navigationDestination(isPresented: Binding(
                
                // 詳細画面の表示
                get: { selectedCrop != nil },
                set: { newValue in
                    if !newValue { selectedCrop = nil }
                })
            ) {
                if let crop = selectedCrop {
                    DetailCropView(crop: crop)
                }
            }
        }
    }

    //==================================================//
    //  MARK: - リスト削除
    //==================================================//
    
    private func deleteCrop(at offsets: IndexSet) {
        for index in offsets { modelContext.delete(crops[index]) }
        try? modelContext.save()
    }

    //==================================================//
    //  MARK: - リスト並び替え
    //==================================================//
    private func moveCrop(from source: IndexSet, to destination: Int) {
        // crops は @Query で取得される配列
        var currentCrops = crops.sorted(by: { $0.orderIndex < $1.orderIndex })
        
        // 配列の並べ替え
        currentCrops.move(fromOffsets: source, toOffset: destination)
        
        // 新しい順序で orderIndex を更新
        for (index, crop) in currentCrops.enumerated() {
            crop.orderIndex = index
        }
        
        // 保存
        try? modelContext.save()
    }
}


//==================================================//
//  MARK: - リスト表示
//==================================================//

private struct HeaderView: View {
    
    @Binding var isSheetPresented: Bool
    @Binding var isEditMode: Bool
    
    //==================================================//
    //  MARK: - ビューの設定
    //==================================================//
    var body: some View {
        HStack {
            Text("家庭菜園")
                .font(.largeTitle.weight(.semibold))
            
            Spacer()
            
            HStack(spacing: 12) {
                // ＋ ボタン：追加
                Button {
                    isSheetPresented = true
                } label: {
                    Image(systemName: "plus.app")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.teal)
                        .font(.system(size: 20, weight: .semibold))
                }
                
                // ボタン：編集モード切替
                Button {
                    withAnimation {
                        isEditMode.toggle()
                    }
                } label: {
                    Image(systemName: "pencil")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(isEditMode ? .orange : .teal)
                        .font(.system(size: 20, weight: .semibold))
                }
            }
        }
        .padding()
    }
}

//==================================================//
//  MARK: - ヘッダー
//==================================================//

private struct CropRowView: View {
    @Binding var isEditMode: Bool
    let crop: Crop

    //==================================================//
    //  MARK: - ビューの設定
    //==================================================//
    var body: some View {
        HStack {

// TODO: アイコン追加
//            Image(systemName: crop.icon.iconType)
//                .foregroundColor(crop.colors.colorType)
//                .padding(16)
//                .font(.system(size: 24, weight: .semibold))
            
            Text(crop.name)
                .font(.headline.weight(.semibold))
                .padding(.vertical, 2)
            
            Spacer()
            
// TODO: 自作の chevron（編集モード時は非表示）
//            Image(systemName: "chevron.right")
//                .opacity(isEditMode ? 0 : 1)
//                .foregroundColor(crop.colors.colorType)
//                .font(.system(size: 14, weight: .medium))
//                .padding(16)
        }
        .frame(height: 60)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

//==================================================//
//  MARK: - プレビュー
//==================================================//

#Preview {
    ListCropView()
        .modelContainer(Crop.preview)
}


