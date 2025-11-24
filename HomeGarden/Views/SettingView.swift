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
                        if let url = urlFromInfo("QA") {
                            openWeb(url.absoluteString)
                        }
                    }
                    
                    Button("お問い合わせフォーム") {
                        if let url = urlFromInfo("Contact") {
                            openWeb(url.absoluteString)
                        }
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
    
    //=========================================
    // MARK: - WebURL読込処理
    //=========================================
    private func urlFromInfo(_ key: String) -> URL? {
        guard let dict = Bundle.main.object(forInfoDictionaryKey: "WebLinks") as? [String: String],
              let urlString = dict[key],
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
}

#Preview {
    SettingView()
}
