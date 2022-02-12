//
//  AppDelegate.swift
//  createSymbol
//
//  Created by Mikhailo Dovhyi on 12.02.2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    static var shared:AppDelegate?
    lazy var globals = {
        return Globals()
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.shared = self
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

