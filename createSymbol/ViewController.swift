//
//  ViewController.swift
//  createSymbol
//
//  Created by Mikhailo Dovhyi on 12.02.2022.
//

import Cocoa
import WebKit

class ViewController: NSViewController {

    @IBOutlet weak var exportButton: NSButton!
    @IBOutlet weak var iconButton: NSButton!
    @IBOutlet weak var webKit: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var representedObject: Any? {
        didSet {

        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        
        
    }
    
    
    func validateSelectedIcon(_ selectedString:String) -> String? {
        let template = T.template
        if let cropped = selectedString.slice(from: "<path", to: "path>") {
            let croppedSelectedSVG = "<path " + cropped + "path>"
            let new = template.replacingOccurrences(of: "<123456789>", with: croppedSelectedSVG)

            return new
        }
        return nil

    }
    

    
    var _convertedSVGText:String?
    var convertedSVGText:String? {
        get {
            return _convertedSVGText
        }
        set {
            _convertedSVGText = newValue
            let isNil = newValue == nil
            DispatchQueue.main.async {
                self.exportButton.isEnabled = !isNil
                self.iconButton.title = isNil ? "Tap to choose icon" : ""
                self.webKit.isHidden = isNil
            }
        }
    }
    
    
    @IBAction func exportPressed(_ sender: NSButton) {
        print("export pressed")
        if let svgText = convertedSVGText {
            let save = NSSavePanel()
            save.allowedFileTypes = ["svg"]
            
            save.begin { response in
                if let url = save.url {
                    do {
                        try svgText.write(to: url, atomically: true, encoding: .utf8)
                        
                    } catch {
                        print("error saving")
                    }
                } else {
                    print("error url")
                }
                
            }
        }
    }
    
    @IBAction func addIconPressed(_ sender: NSButton) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose a file| Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;
        dialog.allowedFileTypes = ["svg"]
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                if let path: String = result?.path {
                    if path.contains(".svg") {
                        let fileManager = FileManager.default
                        if let content = fileManager.contents(atPath: path) {
                            let selectedString = String(decoding: content, as: UTF8.self)
                            
                            if let convertedSVG = validateSelectedIcon(selectedString) {

                                convertedSVGText = convertedSVG
                                print("resultt:\n" + convertedSVG)
                                let html = unparseHTML(svg: selectedString)
                                print("html:", html, "htmlhtmlhtml")
                                webKit.loadHTMLString(html, baseURL: nil)
                            }
                        } else {
                            print("error converting file")
                        }
                    } else {
                        print("not allowed format, choose svg file")
                    }
                }
            }
            
        } else {
            return
        }
    }
    
    func unparseHTML(svg:String) -> String {
        let head = """
<!DOCTYPE html><html lang=\"en\"><head><style type="text/css">body{background:#262626;}svg{width: 100%;height: 100%;}</style></head>
"""
        let content = svg
        let footer = "</body></html>"
        return head + "<body>" + content + footer
        
    }

}

