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
//  09/15/23    Remember current page
//  09/15/23    Fix not main thread warning
//
//  Fixed
//  09/15/23    Open external links in Safari *FIXED 09/15/23*

@main
struct ff2App: App {
    //public static var mainURL:String = "https://taurus.com"
    private static var hardScheme:String = "https://"
    private static var hardHost:String = "www.fatalflawlit.com"

    public static func mainScheme() -> String {
        hardScheme
    }
    public static func mainHost() -> String {
        hardHost
    }
    public static func mainURL() -> String {
        hardScheme + hardHost
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
