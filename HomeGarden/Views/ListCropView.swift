//==================================================//
//  MARK: - ListCropView.swift
//  作成者: konishi
//  作成日: 2025/10/07
//  説明  : 作物(Crop)一覧を表示し、追加・編集・アーカイブ・並び替えを行う画面
//==================================================//

import SwiftUI
import SwiftData

//==================================================//
//  MARK: - 作物一覧ビュー
//==================================================//
struct ListCropView: View {
    
    //==================================================//
    //  MARK: - Environment
    //==================================================//
    @Environment(\.modelContext) private var modelContext
    
    //==================================================//
    //  MARK: - データ
    //==================================================//
    @Query(
        filter: #Predicate<Crop> { !$0.isArchived },
        sort: [SortDescriptor(\Crop.orderIndex)]
    ) private var crops: [Crop]
    
    //==================================================//
    //  MARK: - 状態管理
    //==================================================//
    @State private var isFormPresented = false       // 新規追加フォーム表示フラグ
    @State private var isEditMode = false            // 並び替えモードフラグ
    @State private var selectedCrop: Crop?           // 作業一覧画面へ遷移する作物
    @State private var editingCrop: Crop?            // 編集対象の作物
    
    //==================================================//
    //  MARK: - 定数
    //==================================================//
    private let emptyListTopPadding: CGFloat = 200   // 空リスト時の余白
    
    //==================================================//
    //  MARK: - Body
    //==================================================//
    var body: some View {
        NavigationStack {
            VStack {
                headerView
                cropListView
            }
            // 編集フォームの表示
            .sheet(item: $editingCrop) { crop in
                FormCropView(editingCrop: crop)
            }
            // 新規作物追加フォーム
            .sheet(isPresented: $isFormPresented) {
                FormCropView()
            }
            // 作業一覧画面への遷移
            .navigationDestination(isPresented: Binding(
                get: { selectedCrop != nil },
                set: { newValue in if !newValue { selectedCrop = nil } })
            ) {
                if let crop = selectedCrop {
                    ListActivityView(crop: crop)
                }
            }
        }
    }
    
    //==================================================//
    //  MARK: - ヘッダー部分
    //==================================================//
    private var headerView: some View {
        
        Text("家庭菜園")
            .foregroundColor(Color("FontColor"))
            .font(.largeTitle.weight(.semibold))
        
    }
    
    //==================================================//
    //  MARK: - 作物リスト
    //==================================================//
    private var cropListView: some View {
        List {
            ForEach(crops) { crop in
                cropRow(crop)
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        // アーカイブ操作
                        Button {
                            archiveCrop(crop)
                        } label: {
                            Label("アーカイブ", systemImage: "archivebox")
                        }
                        .tint(.gray)
                    }
            }
            // 並び替え処理
            .onMove(perform: moveCrop)
            
            // 空リスト時の表示
            if crops.isEmpty {
                HStack {
                    Spacer()
                    Image(systemName: "folder")
                        .foregroundStyle(.gray)
                        .font(.system(size: 50, weight: .thin))
                    Spacer()
                }
                .padding(.top, emptyListTopPadding)
            }
            
            // 作物追加ボタン
            addCropButton
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .environment(\.editMode, .constant(isEditMode ? .active : .inactive))
    }
    
    //==================================================//
    //  MARK: - 作物行ビュー
    //==================================================//
    private func cropRow(_ crop: Crop) -> some View {
        Button {
            guard !isEditMode else { return }
            selectedCrop = crop
        } label: {
            CropRowView(isEditMode: $isEditMode, crop: crop)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .listRowInsets(.init(top: 10, leading: 20, bottom: 10, trailing: 10))
        .listRowSeparator(.hidden)
        .cornerRadius(16)
    }
    
    //==================================================//
    //  MARK: - 新規追加ボタン
    //==================================================//
    private var addCropButton: some View {
        Button {
            isFormPresented = true
        } label: {
            HStack {
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.teal)
                    .font(.system(size: 22, weight: .bold))
                Text("新しい野菜を追加")
                    .font(.headline)
                    .foregroundColor(.teal)
                Spacer()
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.clear)
        .opacity(isEditMode ? 0 : 1)
        .listRowSeparator(.hidden)
    }
    
    //==================================================//
    //  MARK: - リスト操作
    //==================================================//
    
    /// 並び替え処理
    private func moveCrop(from source: IndexSet, to destination: Int) {
        // 並び順を保持した配列を一時作成
        var sortedCrops = crops.sorted { $0.orderIndex < $1.orderIndex }
        sortedCrops.move(fromOffsets: source, toOffset: destination)
        
        // 新しい順番に基づいて orderIndex を更新
        for (index, crop) in sortedCrops.enumerated() {
            crop.orderIndex = index
        }
        try? modelContext.save()
    }
    
    /// 指定された作物をアーカイブ化
    private func archiveCrop(_ crop: Crop) {
        crop.isArchived = true
        try? modelContext.save()
    }
}

//==================================================//
//  MARK: - 作物行コンポーネント
//==================================================//
private struct CropRowView: View {
    @Binding var isEditMode: Bool
    let crop: Crop
    
    var body: some View {
        HStack {
            // 作物アイコン
            Image(crop.icon.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(crop.displayColor)
                .padding(16)
            
            // 作物名
            Text(crop.name)
                .foregroundColor(Color("FontColor"))
                .font(.headline.weight(.semibold))
                .padding(.vertical, 2)
            
            Spacer()
            
            // 右矢印（編集モードでは非表示）
            Image(systemName: "chevron.right")
                .opacity(isEditMode ? 0 : 1)
                .foregroundColor(crop.displayColor)
                .font(.system(size: 14, weight: .medium))
                .padding(16)
        }
        .frame(height: 60)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

//==================================================//
//  MARK: - Preview
//==================================================//
#Preview("Default") {
    ListCropView()
        .modelContainer(Crop.preview)
}

#Preview("Empty") {
    ListCropView()
}

