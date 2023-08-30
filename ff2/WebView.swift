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

    typealias UIViewType = WKWebView

    let webView: WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }
}
