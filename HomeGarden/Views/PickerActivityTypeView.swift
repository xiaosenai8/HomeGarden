//==================================================//
//  MARK: - PickerActivityTypeView.swift
//  作成者: konishi
//  作成日: 2025/10/18
//  説明  : アクティビティを選択するビュー
//==================================================//

import SwiftUI

struct PickerActivityTypeView: View {
    // 親から選択状態を受け取る（双方向バインディング）
    @Binding var selectedActivity: ActivityType
    @Environment(\.dismiss) private var dismiss
    
    // グリッド設定
    private let columns = [
        GridItem(.adaptive(minimum: 70), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(ActivityType.allCases) { activity in
                        iconButton(for: activity)
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6)) // スクロール領域の背景
            .navigationTitle("作業を選択")
        }
    }
    
    //==================================================//
    // MARK: - アイコンボタン
    //==================================================//
    private func iconButton(for activity: ActivityType) -> some View {
        Button {
            selectedActivity = activity
            dismiss()
        } label: {

            VStack(spacing: 8) {
                Image(systemName: activity.activityIcon)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.teal)
                    .opacity(0.8)
                Text(activity.activityName)
                    .font(.footnote)
                    .foregroundColor(.teal)
            }
            
            .frame(width: 70, height: 70)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selectedActivity == activity ? Color.teal : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

//==================================================//
//  MARK: - Preview
//==================================================//
#Preview {
    // Binding を作るには .constant を使う
    PickerActivityTypeView(selectedActivity: .constant(.watering))
}


