//==================================================//
//  MARK: - PickerCropIconView.swift
//  作成者: konishi
//  作成日: 2025/10/18
//  説明  : 作物アイコンを選択するビュー
//==================================================//

import SwiftUI

struct PickerCropIconView: View {
    
    // 親から選択状態を受け取る（双方向バインディング）
    @Binding var selectedIcon: CropIcon
    @Environment(\.dismiss) private var dismiss
    
    // グリッド設定
    private let columns = [
        GridItem(.adaptive(minimum: 70), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(CropIcon.allCases) { icon in
                        iconButton(for: icon)
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6)) // スクロール領域の背景
            .navigationTitle("アイコンを選択")
        }
    }
    
    //==================================================//
    // MARK: - アイコンボタン
    //==================================================//
    private func iconButton(for icon: CropIcon) -> some View {
        Button {
            selectedIcon = icon
            dismiss()
        } label: {
            VStack(spacing: 8) {
                Image(icon.iconName)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.red)
                    .opacity(0.8)
            }
            .frame(width: 70, height: 70)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selectedIcon == icon ? Color.teal : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

//==================================================//
//  MARK: - Preview
//==================================================//
#Preview {
    PickerCropIconView(selectedIcon: .constant(.tomato))
}


