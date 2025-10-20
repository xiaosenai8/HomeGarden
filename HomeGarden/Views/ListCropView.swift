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
    
    @State private var isFormPresented = false       // 新規追加フォーム表示
    @State private var isEditMode = false           // 編集モード
    @State private var selectedCrop: Crop?          // 遷移先用
    @State private var editingCrop: Crop?           // 編集対象
    
    //==================================================//
    //  MARK: - Body
    //==================================================//
    var body: some View {
        NavigationStack {
            VStack {
                headerView
                cropListView
            }
            // 編集フォームシート
            .sheet(item: $editingCrop) { crop in
                FormCropView(editingCrop: crop)
            }
            // 新規追加フォームシート
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
    //  MARK: - ヘッダー
    //==================================================//
    private var headerView: some View {
        HStack {
            Text("家庭菜園")
                .font(.largeTitle.weight(.semibold))
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    isFormPresented = true
                } label: {
                    Image(systemName: "plus.app")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.teal)
                        .font(.system(size: 20, weight: .semibold))
                }
                
                Button {
                    withAnimation { isEditMode.toggle() }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(isEditMode ? .orange : .teal)
                        .font(.system(size: 20, weight: .semibold))
                }
            }
        }
        .padding()
    }
    
    //==================================================//
    //  MARK: - 作物リスト
    //==================================================//
    private var cropListView: some View {
        List {
            ForEach(crops) { crop in
                cropRow(crop)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            editingCrop = crop
                        } label: {
                            Label("編集", systemImage: "pencil")
                        }
                        .tint(.teal)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button {
                            archiveCrop(crop)
                        } label: {
                            Label("アーカイブ", systemImage: "archivebox")
                        }
                        .tint(.gray)
                    }
            }
            .onMove(perform: moveCrop)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .environment(\.editMode, .constant(isEditMode ? .active : .inactive))
    }
    
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
        .cornerRadius(10)
    }
    
    //==================================================//
    //  MARK: - リスト操作
    //==================================================//
    
    private func moveCrop(from source: IndexSet, to destination: Int) {
        var sortedCrops = crops.sorted { $0.orderIndex < $1.orderIndex }
        sortedCrops.move(fromOffsets: source, toOffset: destination)
        for (index, crop) in sortedCrops.enumerated() {
            crop.orderIndex = index
        }
        try? modelContext.save()
    }
    
    private func archiveCrop(_ crop: Crop) {
        crop.isArchived = true
        try? modelContext.save()
    }
}

//==================================================//
//  MARK: - 作物行ビュー
//==================================================//
private struct CropRowView: View {
    @Binding var isEditMode: Bool
    let crop: Crop
    
    var body: some View {
        HStack {
            Image(crop.icon.iconName)
                .foregroundColor(crop.color.cropColor)
                .padding(16)
                .font(.system(size: 24, weight: .semibold))
            
            Text(crop.name)
                .font(.headline.weight(.semibold))
                .padding(.vertical, 2)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .opacity(isEditMode ? 0 : 1)
                .foregroundColor(crop.color.cropColor)
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
#Preview {
    ListCropView()
        .modelContainer(Crop.preview)
}

