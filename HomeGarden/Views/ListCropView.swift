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
    @Query(
        filter: #Predicate<Crop> { !$0.isArchived },
        sort: [SortDescriptor(\Crop.orderIndex)]
    )
    
    private var crops: [Crop]
    @State private var isSheetPresented = false
    @State private var isEditMode = false
    @State private var selectedCrop: Crop?
    
    //==================================================//
    //  MARK: - ビュー
    //==================================================//
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // ヘッダー
                HeaderView(isSheetPresented: $isSheetPresented, isEditMode: $isEditMode)
                
                // リスト
                List {
                    ForEach(crops) { crop in
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
                        
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                // TODO:
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
                    .onDelete(perform: deleteCrop)
                    .onMove(perform: moveCrop)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .environment(\.editMode, .constant(isEditMode ? .active : .inactive))
            }
            .sheet(isPresented: $isSheetPresented) {
                FormCropView()
            }
            .navigationDestination(isPresented: Binding(
                get: { selectedCrop != nil },
                set: { newValue in
                    if !newValue { selectedCrop = nil }
                })
            ) {
                if let crop = selectedCrop {
                    ListActivityView(crop: crop)
                }
            }
        }
    }
    
    //==================================================//
    //  MARK: - リスト操作
    //==================================================//
    
    private func deleteCrop(at offsets: IndexSet) {
        for index in offsets { modelContext.delete(crops[index]) }
        try? modelContext.save()
    }
    
    private func moveCrop(from source: IndexSet, to destination: Int) {
        var currentCrops = crops.sorted(by: { $0.orderIndex < $1.orderIndex })
        currentCrops.move(fromOffsets: source, toOffset: destination)
        for (index, crop) in currentCrops.enumerated() {
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
//  MARK: - ヘッダー
//==================================================//

private struct HeaderView: View {
    @Binding var isSheetPresented: Bool
    @Binding var isEditMode: Bool
    
    var body: some View {
        HStack {
            Text("家庭菜園")
                .font(.largeTitle.weight(.semibold))
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    isSheetPresented = true
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
}

//==================================================//
//  MARK: - リスト行
//==================================================//

private struct CropRowView: View {
    @Binding var isEditMode: Bool
    let crop: Crop
    
    var body: some View {
        HStack {
            Image(systemName: crop.icon.cropIcon)
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
//  MARK: - プレビュー
//==================================================//

#Preview {
    ListCropView()
        .modelContainer(Crop.preview)
}

