//
//  SettingView.swift
//  HomeGarden
//  
//  Created by konishi on 2025/10/07
//  
//

import SwiftUI

struct SettingView: View {
    
    @AppStorage("showArchived") private var showArchived: Bool = false
    
    @State private var showDebugView = false
    @State private var secretCounter = 0
    
    // App 内 WebView 用
    @State private var showWebView = false
    @State private var webViewURL: URL? = nil
    
    private let appVersion: String =
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    
    var body: some View {
        NavigationStack {
            List {
                
                //===========================
                //  表示設定（アーカイブ）
                //===========================
                Section("表示設定") {
                    Toggle("アーカイブを表示する", isOn: $showArchived)
                }
                
                
                //===========================
                //  アプリ情報
                //===========================
                Section("アプリ情報") {
                    
                    HStack {
                        Text("バージョン")
                        Spacer()
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }
                    
                    //---- 隠しコマンド ----//
                    HStack {
                        Text("おまけ設定")
                        Spacer()
                        Text("？？？")
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        secretCounter += 1
                        if secretCounter == 5 {
                            showDebugView = true
                            secretCounter = 0
                        }
                    }
                }
                
                
                //===========================
                //  Webリンク（アプリ内表示）
                //===========================
                Section("リンク") {
                    
                    Button("Q&A") {
                        openWeb("https://example.com/qa")
                    }
                    
                    Button("お問い合わせフォーム") {
                        openWeb("https://example.com/contact")
                    }
                    
                    Button("お知らせ") {
                        openWeb("https://example.com/news")
                    }
                }
            }
            .navigationTitle("設定")
            
            //---------------------------------------------------
            // App 内 WebView
            //---------------------------------------------------
            .sheet(isPresented: $showWebView) {
                if let url = webViewURL {
                    WebViewContainer(url: url, isPresented: $showWebView)
                }
            }
            
            //---------------------------------------------------
            // 隠しコマンド DebugDataView
            //---------------------------------------------------
            .sheet(isPresented: $showDebugView) {
                DebugDataView()
            }
        }
    }
    
    //=========================================
    // MARK: - Web表示処理
    //=========================================
    private func openWeb(_ urlString: String) {
        if let url = URL(string: urlString) {
            webViewURL = url
            showWebView = true
        }
    }
}

#Preview {
    SettingView()
}
