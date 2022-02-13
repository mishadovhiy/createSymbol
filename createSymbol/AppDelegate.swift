//
//  AppDelegate.swift
//  createSymbol
//
//  Created by Mikhailo Dovhyi on 12.02.2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window:NSWindow?
    
    static var shared:AppDelegate?
    lazy var globals = {
        return Globals()
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.shared = self
    }

    
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        print("will term")
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func newWindow() {
        DispatchQueue.main.async {
            /*let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
            let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
            let task = Process()
            task.launchPath = "/usr/bin/open"
            task.arguments = [path]
            task.launch()
            exit(0)*/
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let myWindowController = storyboard.instantiateController(withIdentifier: "Window") as! Window
                myWindowController.showWindow(self)
        }
    }
    
    @IBOutlet weak var reopenButton: NSMenuItem!
    @IBAction func reopenPressed(_ sender: NSMenuItem) {
        newWindow()
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        print(#function)
        //reopen() //if close pressed
        
        return true
    }
    
    func applicationDidChangeOcclusionState(_ notification: Notification) {
        print(#function)
    }
    
}

