//
//  ViewController.swift
//  ff2
//
//  Created by Dave Elward on 9/18/23.
//

import Foundation
import UIKit
import WebKit

class ViewController: NSObject, UIScrollViewDelegate, WKUIDelegate {
    
    var parent: WebView
    
    init(_ parent: WebView) {
        print("Called init ViewController()")
        self.parent = parent
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let co = scrollView.contentOffset
        let cs = scrollView.contentSize
        print("Called scrollViewDidScroll() x=\(co.x) y=\(co.y) width=\(cs.width) height=\(cs.height)")
   }
}

