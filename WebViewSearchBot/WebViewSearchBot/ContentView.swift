//
//  ContentView.swift
//  WebViewSearchBot
//
//  Created by Tim Sonner on 2/28/23.
//

import SwiftUI
import WebKit

struct ContentView: View {
    let sites = ["https://www.google.com", "https://www.apple.com", "https://www.microsoft.com"]
    
    var body: some View {
        List(sites, id: \.self) { site in
            WebView(site: site)
        }
    }
}

struct WebView: View {
    let site: String
    @State private var webView: WKWebView?
    private let navigationDelegate = NavigationDelegate()
    
    var body: some View {
        VStack {
            if webView != nil {
                WebViewWrapper(webView: webView!)
                    .frame(maxHeight: .infinity)
            } else {
                Text("Loading...")
                    .frame(maxHeight: .infinity)
            }
        }
        .onAppear {
            let webView = WKWebView()
            webView.navigationDelegate = navigationDelegate
            webView.load(URLRequest(url: URL(string: site)!))
            self.webView = webView
        }
        .onDisappear {
            webView?.stopLoading()
            webView?.navigationDelegate = nil
            webView = nil
        }
    }
}

struct WebViewWrapper: UIViewRepresentable {
    let webView: WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

class NavigationDelegate: NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Loaded \(webView.url?.absoluteString ?? "")")
        webView.removeFromSuperview()
        webView.navigationDelegate = nil
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
