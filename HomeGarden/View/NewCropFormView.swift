//
//  NewCropFormView.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/05
//  
//

import SwiftUI
import SwiftData

struct NewCropFormView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var selsctedIcon: Icon = .tomato
    @State private var selsctedColor: Colors = .teal
    
    private func addNewCrop(){
        let newCrop = Crop(name: name, icon: selsctedIcon, colors: selsctedColor)
        modelContext.insert(newCrop)
        name = ""
        selsctedIcon = .tomato
        selsctedColor = .teal
    }
    
    var body: some View {
        
        NavigationView  {
            
            Form{
                
                // MARK: - NAME
                Section {
                    TextField("", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .font(.largeTitle.weight(.light))
                } header: {
                    Text("野菜の名前")
                }
                
                Section {
                    // MARK: - ICON
                    Picker("アイコン", selection: $selsctedIcon){
                        ForEach(Icon.allCases){icon in
                            HStack{
                                Image(systemName: icon.iconType)
                                Text(icon.name)
                            }
                            .tag(icon)
                        }
                    }
                    
                    // MARK: - COLOR
                    Picker("カラー", selection: $selsctedColor){
                        ForEach(Colors.allCases){color in
                            Image(systemName: "circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(color.colorType)
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
                    
                // MARK: - SAVE BUTTON
                Button{
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
                
                // MARK: - CANCEL BUTTON
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
