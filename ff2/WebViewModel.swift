//
//  WebViewModel.swift
//  ff2
//
//  Created by Dave Elward on 8/24/23.
//

import Combine
import WebKit

class WebViewModel: ObservableObject {
    let webView: WKWebView
    
    // See: https://www.hackingwithswift.com/articles/112/the-ultimate-guide-to-wkwebview

    private let navigationDelegate: WebViewNavigationDelegate
    private var zoomMagnification:CGFloat = 1.0

    init(hardURLString : String) {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: .zero, configuration: configuration)
        navigationDelegate = WebViewNavigationDelegate()

        webView.navigationDelegate = navigationDelegate
        setupBindings()
        loadUrlString(urlStr : hardURLString)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @Published var urlString: String = ""
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var isLoading: Bool = false

    private func setupBindings() {
        webView.publisher(for: \.canGoBack)
            .assign(to: &$canGoBack)

        webView.publisher(for: \.canGoForward)
            .assign(to: &$canGoForward)

        webView.publisher(for: \.isLoading)
            .assign(to: &$isLoading)

    }

    func loadUrl() {
        guard let url = URL(string: urlString) else {
            return
        }

        webView.load(URLRequest(url: url))
    }

    func loadUrlString(urlStr : String) {
        urlString = urlStr
        loadUrl()
    }

    func goForward() {
        webView.goForward()
    }

    func refreshPage() {
        webView.reload()
    }

    func goBack() {
        webView.goBack()
    }
    
    func zoomIn () {
        zoomMagnification *= 1.5
        webView.pageZoom = zoomMagnification
    }
    
    func zoomOut () {
        zoomMagnification /= 1.5
        webView.pageZoom = zoomMagnification
    }
}
