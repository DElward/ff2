//
//  WebViewNavigationDelegate.swift
//  ff2
//
//  Created by Dave Elward on 8/24/23.
//

import WebKit

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    
    private var zoomPercent:CGFloat = 100.0
    private var isZoomed: Bool = false
    private var currentPage: String?
    
    func setZoom(newZoom : CGFloat) {
        zoomPercent = newZoom * 100.0
        isZoomed = true
    }
    
    func okToLoad(_ navigationAction: WKNavigationAction) -> WKNavigationActionPolicy {
        
        var policy: WKNavigationActionPolicy = WKNavigationActionPolicy.cancel
        let req = navigationAction.request
        let url = req.url
        //let sch = url?.scheme
        //let relPath = url?.relativePath
        if let hst = url?.host {
            if hst == ff2App.mainHost() {
                policy = WKNavigationActionPolicy.allow
            }
        }
        
        return policy
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // TODO
        let policy: WKNavigationActionPolicy = okToLoad(navigationAction)
        
        if policy == WKNavigationActionPolicy.cancel {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url)
            }
        } else {
            if let url = navigationAction.request.url {
                currentPage = url.path
            }
        }
        
        decisionHandler(policy)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        // TODO
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Current page: \(currentPage ?? "Nil")")
        if isZoomed {
            let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='\(zoomPercent.rounded())%'"
            webView.evaluateJavaScript(js, completionHandler: nil)
            if zoomPercent.rounded() == 100.0 {
                isZoomed = false
            }
        }
        let sv = webView.scrollView
        let rect = CGRect(x: 0, y: 255.0, width: 393, height: 6357) // x=0.0 y=255.0 width=393.0 height=6357.0
        sv.scrollRectToVisible(rect, animated: false)
        let co = sv.contentOffset
        let cs = sv.contentSize
        let fr = sv.frame
        print("Called webView() x=\(co.x) y=\(co.y) width=\(cs.width) height=\(cs.height)")
        print("           frame x=\(fr.origin.x) y=\(fr.origin.y) width=\(fr.width) height=\(fr.height)")
    }
}
