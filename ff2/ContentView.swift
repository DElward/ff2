//
//  ContentView.swift
//  ff2
//
//  Created by Dave Elward on 8/24/23.
//

import Combine
import WebKit
import SwiftUI

struct ContentView: View {
    
    @StateObject var model = WebViewModel(hardURLString: ff2App.mainURL())
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .ignoresSafeArea()
            
            WebView(hardURLString: ff2App.mainURL(), webView: model.webView)
            
            if model.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    model.goBack()
                }, label: {
                    Image(systemName: "arrow.left.circle")
                })
                .disabled(!model.canGoBack)

                Button(action: {
                    model.loadUrlString(urlStr: ff2App.mainURL())
                }, label: {
                    Image(systemName: "house")
                })

                Button(action: {
                    model.goForward()
                }, label: {
                    Image(systemName: "arrow.right.circle")
                })
                .disabled(!model.canGoForward)
//                Menu {
//                    Button("Services", action: openCurrentIssue)
//                } label: {
//                    Label("PDF", systemImage: "doc.fill")
//                }
                Spacer()
//                Button(action: {
//                    openCurrentIssue()
//                }, label: {
//                    Image(systemName: "magazine")
//                })
//                Button(action: openCurrentIssue) {
//                        Label("Current Issue", systemImage: "magazine")
//                    }
                Button(action: refreshPage) {
                        Label("Refresh", systemImage: "arrow.clockwise.circle")
                    }
                Button(action: zoomOut) {
                        Label("Zoom Out", systemImage: "minus.magnifyingglass")
                    }
                Button(action: zoomOne) {
                        Label("Zoom One", systemImage: "1.magnifyingglass")
                    }
                Button(action: zoomIn) {
                        Label("Zoom In", systemImage: "plus.magnifyingglass")
                    }
                Spacer()
            }
        }
    }
    
//    func openCurrentIssue () {
//        model.loadUrlString(urlStr: ff2App.mainURL() + "/Services")
//    }
    
    func zoomIn () {
        model.zoomIn()
    }
    
    func zoomOne () {
        model.zoomOne()
    }

    func zoomOut () {
        model.zoomOut()
    }
    
    func refreshPage () {
        model.refreshPage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
