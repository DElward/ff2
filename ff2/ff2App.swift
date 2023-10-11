//
//  ff2App.swift
//  ff2
//
//  Created by Dave Elward on 8/24/23.
//

import SwiftUI

// Todo:
//  09/15/23    Fix not main thread warning
//
//  Fixed
//  09/15/23    Open external links in Safari *FIXED 09/15/23*
//  09/15/23    Remember scroll position *FIXED 10/09/23*
//                  See: https://developer.apple.com/documentation/uikit/view_controllers/preserving_your_app_s_ui_across_launches
//  09/15/23    Remember current page *FIXED 10/09/23*
//  09/28/23    Provide app icon(s) *FIXED 10/09/23*
//  10/09/23    Back does not work, always goes home *FIXED 10/09/23*
//  09/15/23    Handle URL errors *FIXED 10/10/23*
///
//  Issues
//  09/28/23    Long links in Safari (hold down buttom, select Open Link)
//  10/09/23    Only one icon used
//  10/10/23    Top of screen does not show time, battery, signal strength
//
//  Documentation:
//      https://developer.apple.com/documentation/webkit/wkwebview

@main
struct ff2App: App {
    private static var hardScheme:String = "https://"
    private static var hardLocalHost:String = "www"
    private static var hardDomain:String = "fatalflawlit.com"
    private static var hardPage:String = "/"
    private static var dataFileName = "FatalFlaw"

    public static func mainDomain() -> String {
        hardDomain
    }

    public static func mainHost() -> String {
        hardLocalHost + "." + hardDomain
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
        hardScheme + hardLocalHost + "." + hardDomain
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
