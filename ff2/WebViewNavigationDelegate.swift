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
    
    func getErrorHtml(_ errMsg : String, urlString : String) -> String {
        // <a href="javascript:window.history.back();">Back</a>
        var errHtml : String
        errHtml = """
<!DOCTYPE html>
<html>
<head>
    <link rel=stylesheet type="text/css" href="page-load-errors.css">
    <!-- LOCALIZERS: You might want to change the font family. You can also add styles to override sizes, etc. -->
    <style>
        body {font-family:'-apple-system-font';}
    </style>
    <style type="text/css">
        .content-container
        {
            min-width: 320px;
            max-width: 960px;
            margin: 0 auto;
            position: relative;
            width: 50%;
        }

        .error-container
        {
        }

        .text-container
        {
            color: rgb(133, 133, 133);
            position: relative;
            width: 100%;
            word-wrap: break-word;
        }

        .error-title
        {
            font-size: 28px;
            font-weight: 700;
            line-height: 34px;
            margin: 0 auto;
        }

        .error-message
        {
            font-size: 24px;
            line-height: 28px;
            padding: 0px 18px;
        }
    </style>
    <title>Error opening page</title>
</head>

<body>
    <h1 align=center>Error accessing webpage:</h1>
    <h1 align=center>\(urlString)</h1>
    <div class="content-container">
        <div class="error-container">
            <div class="text-container">
                <!-- Main title here. -->
                <p class="error-title">\(errMsg)</p>
            </div>
            <div class="text-container">
                <!-- Error message here. -->
                <p class="error-message">Cannot open the page “\(urlString)”</p>
                <p class="error-message">Error: \(errMsg)</p>
            </div>
            <button onclick="history.back()">Go Back</button>
        </div>
    </div>
</body>
</html>
"""
        return errHtml
    }
    
    func setCurrentScrollPosition(_ scrollPosition: CGPoint) {
//        print("WebViewNavigationDelegate.setCurrentScrollPosition() x=\(scrollPosition.x) y=\(scrollPosition.y)")
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
//        print("WebViewNavigationDelegate.setNewScrollPosition() x=\(newPosition.x) y=\(newPosition.y)")
        newScrollPosition = newPosition
        isNewScrollPosition = true
    }
    
    func okToLoad(_ navigationAction: WKNavigationAction) -> WKNavigationActionPolicy {
        var policy: WKNavigationActionPolicy = WKNavigationActionPolicy.cancel
        let req = navigationAction.request
        let url = req.url
        //let sch = url?.scheme
        //let relPath = url?.relativePath
        if url?.absoluteString == "about:blank" {
            policy = WKNavigationActionPolicy.allow
        } else {
            if let dom = url?.domain {
                if dom.lowercased() == ff2App.mainDomain().lowercased() {
                    policy = WKNavigationActionPolicy.allow
                }
            }
        }
        
        return policy
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // TODO
        print("5. WebViewNavigationDelegate.webView(decidePolicyFor) URL: \(navigationAction.request.url!.absoluteURL)")
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
    
//    func setScrollPositionNow(_ webView: WKWebView, scrollPosition: CGPoint) {
//        webView.scrollView.setContentOffset(scrollPosition, animated: false)
//    }
    
//    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
//        // TODO
//        print("8. WebViewNavigationDelegate.webView(decidePolicyForNavigationAction) Current page: \(currentPage)")
//        decisionHandler(.allow)
//    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // Called when there is an error
        
        var errHtml : String?
        
        print("7. WebViewNavigationDelegate.webView(didFailProvisionalNavigation) Current page: \(currentPage)")
        
        if let err = error as? URLError {
            switch(err.code) {  //  Exception occurs on this line
            case .cancelled:
                errHtml =  getErrorHtml("Operation cancelled", urlString: currentPage)
                
            case .cannotFindHost:
                errHtml =  getErrorHtml("Cannot Find Host", urlString: currentPage)
                
            case .notConnectedToInternet:
                errHtml =  getErrorHtml("Not Connected to the Internet", urlString: currentPage)
                
            case .resourceUnavailable:
                errHtml =  getErrorHtml("Resource Unavailable", urlString: currentPage)
                
            case .timedOut:
                errHtml =  getErrorHtml("Operation Timed Out", urlString: currentPage)
                
            default:
                errHtml =  getErrorHtml("Operation failed with " + String(describing: err.code), urlString: currentPage)
            }
            
            if (errHtml != nil) {
                //  webView.loadHTMLString(errHtml!, baseURL: Bundle.main.resourceURL)
                //  webView.loadHTMLString(errHtml!, baseURL: nil)
                webView.loadHTMLString(errHtml!, baseURL: URL(string: ff2App.mainURL()))
            }
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        // TODO
        print("8. WebViewNavigationDelegate.webView(decidePolicyFor) Current page: \(currentPage)")
        if let response = navigationResponse.response as? HTTPURLResponse {
            print("9. WebViewNavigationDelegate.webView(decidePolicyFor) Status= \(response.statusCode)")
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let csp = webView.scrollView.contentOffset
        if isZoomed {
//            print("2. Set zoom to \(zoomPercent.rounded())%")
            let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='\(zoomPercent.rounded())%'"
            webView.evaluateJavaScript(js, completionHandler: nil)
            if zoomPercent.rounded() == 100.0 {
                isZoomed = false
            }
        }
        if isNewScrollPosition {
//            print("3. Set new scroll position to x=\(newScrollPosition.x) y=\(newScrollPosition.y)")
            //setScrollPositionNow(webView, scrollPosition: newScrollPosition)
            webView.scrollView.setContentOffset(newScrollPosition, animated: false)
            //webView.scrollView.contentOffset = newScrollPosition
            isNewScrollPosition = false
        }
        currentScrollPosition = webView.scrollView.contentOffset
//        print("4. Called webView() currentScrollPosition is x=\(currentScrollPosition.x) y=\(currentScrollPosition.y)")
//        webView.scrollView.setContentOffset(currentScrollPosition, animated: false)
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

//      ******** Extensions ********

extension URL {
    var domain: String? {
        var domainName = self.host
        if (domainName != nil) {
            if let lastDot = domainName!.lastIndex(of: ".") {
                let pfix = domainName!.prefix(upTo: lastDot)
                if let nextDot = pfix.lastIndex(of: ".") {
                    let dnlen = domainName!.count - nextDot.utf16Offset(in: domainName!) - 1
                    domainName = String(domainName!.suffix(dnlen))
                }
            }
            print("domainName: \(domainName!)")
        }
        return domainName
    }
}
