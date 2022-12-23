//
//  WebViewCode.swift
//  SkinDiseases
//
//  Created by Ankita Chatterjee on 4/16/22.
//

import SwiftUI
import WebKit
 
struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
        print("Loaded request for URL=",url)
    }
}
struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url:URL(string:"https://www.cnn.com")!)
    }
}

