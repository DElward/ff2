//
//  ff2App.swift
//  ff2
//
//  Created by Dave Elward on 8/24/23.
//

import SwiftUI

// Todo:
//  09/15/23    Handle URL errors
//  09/15/23    Remember scroll position
//                  See: https://developer.apple.com/documentation/uikit/view_controllers/preserving_your_app_s_ui_across_launches
//  09/15/23    Remember current page
//  09/15/23    Fix not main thread warning
//
//  Fixed
//  09/15/23    Open external links in Safari *FIXED 09/15/23*
//
// Invalid parameter not satisfying: targetNode

@main
struct ff2App: App {
    //public static var mainURL:String = "https://taurus.com"
    private static var hardScheme:String = "https://"
    private static var hardHost:String = "www.fatalflawlit.com"
    private static var hardPage:String = "/"
    //private var model = WebViewModel(hardURLString: mainURL())

//    public static func mainScheme() -> String {
//        hardScheme
//    }
    public static func mainHost() -> String {
        hardHost
    }
    public static func mainURL() -> String {
        hardScheme + hardHost + hardPage
    }

    var body: some Scene {
        WindowGroup("ff2", id: "ff2.viewer") {
            ContentView()
                //.environmentObject(model)

        }
    }
}
