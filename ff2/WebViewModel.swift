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
    private let magnificationFactor:CGFloat = 11.0 / 8.0    // 1.375
    private var webViewConfig:WebViewConfiguration

    init() {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: .zero, configuration: configuration)
        
        if let codedData = try? Data(contentsOf: WebViewConfiguration.dataModelURL()) {
            // Decode the json file into a DataModel object.
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(WebViewConfiguration.self, from: codedData) {
                webViewConfig = decoded
                print("WebViewModel.init() Read json config -  Current page: \(webViewConfig.currentPage) x=\(webViewConfig.currentScrollPosition.x) y=\(webViewConfig.currentScrollPosition.y)")
           } else {
                print("WebViewModel.init() Error decoding - default config")
                webViewConfig = WebViewConfiguration(currentPage: "/", currentScrollPosition: CGPoint.zero, zoomMagnification: 1.0)
            }
        } else {
            print("WebViewModel.init() default config")
            webViewConfig = WebViewConfiguration(currentPage: "/", currentScrollPosition: CGPoint.zero, zoomMagnification: 1.0)
        }
        
//        let jstr = "{\"zoomMagnification\":1.5,\"currentScrollPosition\":[0,255],\"currentPage\":\"/vol-9-agency\"}"
//        let jdata = Data(jstr.utf8)
//        let decoder = JSONDecoder()
//        if let decoded = try? decoder.decode(WebViewConfiguration.self, from: jdata) {
//            webViewConfig = decoded
//        }

        navigationDelegate = WebViewNavigationDelegate()
        webView.navigationDelegate = navigationDelegate

        if webViewConfig.zoomMagnification != 1.0 {
            navigationDelegate.setZoom(webViewConfig.zoomMagnification)
        }
        if webViewConfig.currentScrollPosition != .zero {
            navigationDelegate.setNewScrollPosition(webViewConfig.currentScrollPosition)
        }
        
        setupBindings()

        let fullURLStr = ff2App.getFullURLString(ff2App.mainSchemeAndHost(),  webViewConfig.currentPage)
        loadUrlString(fullURLStr)
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
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

    func loadUrlString(_ urlStr : String) {
        urlString = urlStr
        loadUrl()
    }

    func goForward() {
        webView.goForward()
    }

    func refreshPage() {
       //let csp = webView.scrollView.contentOffset
       webView.reload()
       //print("-------- Called WebViewModel.refreshPage() contentOffset: x=\(csp.x) y=\(csp.y)")
       //navigationDelegate.setNewScrollPosition(csp)
//        printPagesVisited()
    }

    func goBack() {
        webView.goBack()
    }
    
    func gotoHome () {
        loadUrlString(ff2App.mainURL())
        //BAD// loadUrlString("https://padpage.fatalflawlit.com")
        //navigationDelegate.setNewScrollPosition(.zero)
        webView.scrollView.contentOffset = .zero
        //let csp = webView.scrollView.contentOffset
        //print("-------- Called WebViewModel.gotoHome() contentOffset: x=\(csp.x) y=\(csp.y)")
    }
    
//    func printPagesVisited () {
//        print("Pages visited:")
//        for page in webView.backForwardList.backList {
//            print("User visited \(page.url.absoluteString)")
//        }
//    }

    func setZoom(_ newZoom : CGFloat) {
//        printPagesVisited()
        if let wView = webView.navigationDelegate as? WebViewNavigationDelegate {
            wView.setZoom(newZoom)
            refreshPage()
        }
//        let csp = webView.scrollView.contentOffset
//        print("-------- Called WebViewModel.setZoom(\(newZoom)) contentOffset: x=\(csp.x) y=\(csp.y)")
    }

    func zoomIn () {
        webViewConfig.zoomMagnification *= magnificationFactor
        setZoom(webViewConfig.zoomMagnification)
    }
    
    func zoomOne () {
        webViewConfig.zoomMagnification = 1.0
        setZoom(webViewConfig.zoomMagnification)
    }

    func zoomOut () {
        webViewConfig.zoomMagnification /= magnificationFactor
        //webView.pageZoom = zoomMagnification
        setZoom(webViewConfig.zoomMagnification)
    }

    func save() {
        webViewConfig.currentScrollPosition = navigationDelegate.getCurrentScrollPosition()
        webViewConfig.currentPage = navigationDelegate.getCurrentPage()
        //print("Called model.save: page=\(cp) x=\(sp!.x) y=\(sp!.y)")
        
        webViewConfig.save()
        
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(webViewConfig) {
//            do {
//                // Save the 'Products' data file to the Documents directory.
//                //try encoded.write(to: dataModelURL())
//                if let jsonString = String(data: encoded, encoding: .utf8) {
//                    print("Called model.save")
//                    print(jsonString)
//                }
//            } catch {
//                print("Couldn't write to save file: " + error.localizedDescription)
//            }
//        }
    }
}
