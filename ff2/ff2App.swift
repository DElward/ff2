//
//  ff2App.swift
//  ff2
//
//  Created by Dave Elward on 8/24/23.
//

import SwiftUI

@main
struct ff2App: App {
    //public static var mainURL:String = "https://taurus.com"
    public static var mainURL:String = "https://www.fatalflawlit.com"
    var body: some Scene {
        WindowGroup {
            ContentView(hardURLString: ff2App.mainURL)
        }
    }
}
