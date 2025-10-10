//
//  NewActivityFormView.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/10
//  
//

import SwiftUI
import SwiftData

struct NewActivityFormView: View {
        
        @Environment(\.modelContext) var modelContext
        @Environment(\.dismiss) var dismiss
        let crop: Crop
        
        @State private var selectedType: ActivityType = .watering
        @State private var quantity: Int? = nil
        @State private var quantityString: String = ""
        
        var body: some View {
            NavigationView {
                Form {
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
                    
                    Button("保存") {
                        addActivity()
                        dismiss()
                    }
                }
                .navigationTitle("作業追加")
            }
        }
        
        private func addActivity() {
            let activity = Activity(
                date: Date(),
                type: selectedType,
                quantity: quantity,
                crop: crop
            )
            modelContext.insert(activity)
            try? modelContext.save()
        }
    }
