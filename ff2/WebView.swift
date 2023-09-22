//
//  WebView.swift
//  ff2
//
//  Created by Dave Elward on 8/24/23.
//

import UIKit
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    var hardURLString : String
    var contentInset: UIEdgeInsets = .zero

    typealias UIViewType = WKWebView

    let webView: WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        webView.scrollView.delegate = context.coordinator   // 09/18/2023
        return webView
    }

    // 09/18/2023
    func makeCoordinator() -> ViewController {
        print("Called makeCoordinator()")
        return ViewController(self)
    }
    
    // 09/18/2023
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.scrollView.contentInset != self.contentInset {
            uiView.scrollView.contentInset = self.contentInset
        }
    }
}
