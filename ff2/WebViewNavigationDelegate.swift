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
    private var currentPage: String = ""
    private var currentScrollPosition:CGPoint = .zero
    private var newScrollPosition:CGPoint = .zero
    private var isNewScrollPosition: Bool = false
    
    func setCurrentScrollPosition(_ scrollPosition: CGPoint) {
        currentScrollPosition = scrollPosition
    }
    
    func setZoom(_ newZoom : CGFloat) {
        zoomPercent = newZoom * 100.0
        isZoomed = true
    }
    
    func getCurrentPage() -> String {
        currentPage
    }
    
    func getCurrentScrollPosition() -> CGPoint {
        currentScrollPosition
    }
    
    func setNewScrollPosition(_ newPosition:CGPoint)  {
        print("setNewScrollPosition()")
        newScrollPosition = newPosition
        isNewScrollPosition = true
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
                currentScrollPosition = .zero
            }
        }
        
        decisionHandler(policy)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        // TODO
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebViewNavigationDelegate.webView(didFinish) Current page: \(currentPage)")
        if isZoomed {
            let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='\(zoomPercent.rounded())%'"
            webView.evaluateJavaScript(js, completionHandler: nil)
            if zoomPercent.rounded() == 100.0 {
                isZoomed = false
            }
        }
        if isNewScrollPosition {
            print("adjusted scroll position")
            webView.scrollView.setContentOffset(newScrollPosition, animated: false)
            isNewScrollPosition = false
        }
        currentScrollPosition = webView.scrollView.contentOffset
        print("Called webView() currentScrollPosition x=\(currentScrollPosition.x) y=\(currentScrollPosition.y)")
        //        let sv = webView.scrollView
        //        sv.setContentOffset(CGPoint(x: 0, y: 255), animated: false)
        //        let co = sv.contentOffset
        //        let cs = sv.contentSize
        //        let fr = sv.frame
        //        let sp = sv.layer.position
        //        print("Called webView() x=\(co.x) y=\(co.y) width=\(cs.width) height=\(cs.height)")
        //        print("           frame x=\(fr.origin.x) y=\(fr.origin.y) width=\(fr.width) height=\(fr.height)")
        //        print("  layer.position x=\(sp.x) y=\(sp.y)")
    }
}
