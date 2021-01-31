//
//  WebView.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 28/01/21.
//

/// https://gist.github.com/joshbetz/2ff5922203240d4685d5bdb5ada79105
import SwiftUI
import WebKit

struct Webview: UIViewRepresentable {
    let url: URL

    func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView {
        let webview = WKWebView()

        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)

        return webview
    }

    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<Webview>) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
    }
}
