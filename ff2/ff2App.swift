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
//  09/28/23    Provide app icon(s)
//
//  Fixed
//  09/15/23    Open external links in Safari *FIXED 09/15/23*
//
//  Issues
//  09/28/23    Long links in Safari (hold down buttom, select Open Link)

@main
struct ff2App: App {
    private static var hardScheme:String = "https://"
    private static var hardHost:String = "www.fatalflawlit.com"
    private static var hardPage:String = "/"
    private static var dataFileName = "FatalFlaw"

    public static func mainHost() -> String {
        hardHost
    }
    
    public static func getFullURLString(_ SchemeAndHost:String, _ page:String) -> String {
        var fullURLStr:String
        fullURLStr = SchemeAndHost
        if fullURLStr.hasSuffix("/") {
            if page.hasPrefix("/") {
                fullURLStr = fullURLStr.prefix(fullURLStr.count - 1) + page
            } else {
                fullURLStr += page
            }
        } else {
            if page.hasPrefix("/") {
                fullURLStr += page
            } else {
                fullURLStr += "/" + page
            }
        }

        return fullURLStr
    }

    public static func mainSchemeAndHost() -> String {
        hardScheme + hardHost
    }

    public static func mainURL() -> String {
        getFullURLString(mainSchemeAndHost(),  hardPage)
    }

    public static func getDataFileName() -> String {
        dataFileName
    }

    //private var model: WebViewModel = WebViewModel()  // 09/28/2023
    var body: some Scene {
        WindowGroup("ff2", id: "ff2.viewer") {
            ContentView()
                //.environmentObject(model)
        }
    }
}
