//
//  FormActivityView.swift
//  HomeGarden
//
//  Created by konishi on 2025/10/10
//
//

import SwiftUI
import SwiftData

struct FormActivityView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    let crop: Crop
    
    @State private var selectedType: ActivityType = .watering  // 作業タイプ
    @State private var selectedDate = Date()                   // 作業日
    @State private var quantity: Int? = nil                    // 数量
    @State private var quantityString: String = ""             // 数量入力用文字列
    @State private var comment: String = ""                    // 作業メモ
    
    var body: some View {
        NavigationView {
            Form {
                // 作業日
                Section("作業日") {
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accentColor(.teal)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                }
                
                Section("作業タイプ") {
                    Picker("作業", selection: $selectedType) {
                        ForEach(ActivityType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("数量（任意）") {
                    TextField(
                        "数量を入力",
                        text: Binding(
                            get: { quantityString },
                            set: { newValue in
                                quantityString = newValue
                                quantity = Int(newValue)
                            }
                        )
                    )
                    .keyboardType(.numberPad)
                }
                
                // 作業メモ
                Section() {
                    TextField("", text: $comment)
                        .textFieldStyle(.roundedBorder)
                        .font(.largeTitle.weight(.light))
                } header: {
                    Text("作業メモ")
                }
            }
            .navigationTitle("作業追加")
        }
        // ===== ボタンエリア =====
        VStack(spacing: 12) {
            Button {
                addActivity()
                dismiss()
            } label: {
                Text("追加")
                    .font(.title2.weight(.medium))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle)
            
            Button() {
                dismiss()
            } label: {
                Text("キャンセル")
                    .font(.title2.weight(.medium))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle)
        }
        .padding()
    }
    
    private func addActivity() {
        let activity = Activity(
            date: selectedDate,
            type: selectedType,
            quantity: quantity,
            comment: comment,
            crop: crop
        )
        modelContext.insert(activity)
        crop.activities.append(activity)
        try? modelContext.save()
    }
}

#Preview {
    let sampleCrop = Crop(orderIndex: 0, name: "トマト", icon: .tomato, color: .red)
    FormActivityView(crop: sampleCrop)
}
