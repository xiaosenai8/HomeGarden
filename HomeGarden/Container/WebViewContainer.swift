//
//  WebViewContainer.swift
//  HomeGarden
//
//  Created by konishi on 2025/11/16
//  説明  : アプリ内で WebView を表示するコンテナ画面
//

import SwiftUI
import WebKit

//==================================================//
// MARK: - WebViewContainer
//==================================================//

struct WebViewContainer: View {
    
    //==================================================//
    // MARK: - Properties
    //==================================================//
    
    /// 表示するWebページのURL
    let url: URL
    
    /// 呼び出し元のSheet管理
    @Binding var isPresented: Bool
    
    /// WebViewの戻る可否
    @State private var canGoBack: Bool = false
    
    /// ローディング状態
    @State private var isLoading: Bool = false
    
    
    //==================================================//
    // MARK: - Body
    //==================================================//
    
    var body: some View {
        VStack(spacing: 0) {
            topBar
            loadingIndicator
            Divider()
            webViewArea
        }
        .ignoresSafeArea()
    }
    
    
    //==================================================//
    // MARK: - UI Components
    //==================================================//
    
    /// 上部のコントロールバー
    private var topBar: some View {
        HStack {
            //--------------------------------------------------
            // 戻るボタン
            //--------------------------------------------------
            Button {
                NotificationCenter.default.post(name: .webViewGoBack, object: nil)
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            }
            .disabled(!canGoBack)
            
            Spacer()
            
            //--------------------------------------------------
            // 閉じるボタン
            //--------------------------------------------------
            Button("閉じる") {
                isPresented = false
            }
            .foregroundColor(.red)
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    
    /// ローディングインジケータ
    private var loadingIndicator: some View {
        Group {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.vertical, 4)
            }
        }
    }
    
    
    /// WebView本体
    private var webViewArea: some View {
        WebView(
            url: url,
            isPresented: $isPresented,
            canGoBack: $canGoBack,
            isLoading: $isLoading
        )
    }
}


//==================================================//
// MARK: - Notification Extension
//==================================================//

extension Notification.Name {
    /// WebView に「戻る」を送る通知
    static let webViewGoBack = Notification.Name("webViewGoBack")
}

