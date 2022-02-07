//
//  WebView.swift
//  GitHubRepositorySearchSwiftUI
//
//  Created by yorifuji on 2022/02/07.
//

import SwiftUI
import WebKit

struct WebView: View {
    let url: String
    var body: some View {
        SwiftUIWebView(url: url)
    }
}

struct SwiftUIWebView: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: URL(string: url)!))
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: "https://github.com")
    }
}
