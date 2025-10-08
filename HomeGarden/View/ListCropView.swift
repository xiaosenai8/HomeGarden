//
//  ListCropView.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/07
//  
//

import SwiftUI
import SwiftData

struct ListCropView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query private var crops: [Crop]
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                    HStack {
                        Text("家庭菜園")
                            .font(.title.bold())
                        Spacer()
                        HStack(spacing: 12) {
                            Button {
                                isSheetPresented.toggle()
                            } label: {
                                Image(systemName: "plus.app")
                            }
                            
                            Button {
                                isSheetPresented.toggle()
                            } label: {
                                Image(systemName: "pencil")
                            }
                            
                            Button {
                                isSheetPresented.toggle()
                            } label: {
                                Image(systemName: "arrow.up.arrow.down")
                            }

                        }
                    }
                    .padding()
                
                List {
                    ForEach(crops){crop in
                        
                        HStack {
                            Image(systemName: crop.icon.iconType)
                                .foregroundColor(crop.colors.colorType)
                                .padding(16)
                                .font(.system(size: 24, weight: .medium))
                            Text(crop.name)
                                .font(.headline.weight(.semibold))
                                .padding(.vertical, 2)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(crop.colors.colorType)
                                .font(.system(size: 14, weight: .medium))
                                .padding(16)
                            
                        }
                        .background(
                            NavigationLink("", destination: DetailCropView(crop: crop))
                                .opacity(0)
                        )
                        .buttonStyle(.plain)
                        .frame(height: 60)
                        .background(Color.gray.opacity(0.1))
                        .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 10))
                        .listRowSeparator(.hidden)
                        .cornerRadius(10)
                    }
                    
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                
            }
            .font(.title.bold())
            .sheet(isPresented: $isSheetPresented){
                NewCropFormView()
            }
            
        }//: NavigationStack
    }
}



#Preview {
    ListCropView()
        .modelContainer(Crop.preview)
}
