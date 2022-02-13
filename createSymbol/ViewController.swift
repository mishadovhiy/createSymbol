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
        } else {
            if let cropped = selectedString.slice(from: "<path", to: "/>") {
                let croppedSelectedSVG = "<path " + cropped + "></path>"
                let new = template.replacingOccurrences(of: "<123456789>", with: croppedSelectedSVG)

                return new
            }
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
                      //  print("error saving")
                      //  self.showMessage(title: "Error saving to selected URL", description: "")
                    }
                } else {
                    print("error url")

                    self.showMessage(title: "URL Error", description: "")
                }
                
            }
        } else {

            self.showMessage(title: "Nothing to export", description: "Please, select SVG file again")
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
                            print("selectedd start::\n", selectedString, "\nselectedd")
                            if let convertedSVG = validateSelectedIcon(selectedString) {

                                convertedSVGText = convertedSVG
                                print("resultt:\n" + convertedSVG)
                                if selectedString != "" {
                                    let html = unparseHTML(svg: selectedString)
                                    print("html:", html, "htmlhtmlhtml")
                                    webKit.loadHTMLString(html, baseURL: nil)
                                } else {
                                    self.showMessage(title: "Error converting file", description: "Try another icon")
                                }
                                
                            } else {
                                self.showMessage(title: "Error", description: "This SVG doesn't have path tag")
                            }
                        } else {

                            self.showMessage(title: "Error converting file", description: "Try another icon")
                        }
                    } else {
                        print("not allowed format, choose svg file")

                        self.showMessage(title: "Not allowed format", description: "Choose SVG file")
                    }
                }
            } else {
                self.showMessage(title: "Error loading URL", description: "")
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

    @IBOutlet weak var messageStackView: NSStackView!
    @IBOutlet weak var messageTitleLabel: NSTextField!
    @IBOutlet weak var messageDescriptionLabel: NSTextField!
    
    var timer:Timer?
    func showMessage(title:String, description:String) {
        
        timer?.invalidate()
        let hideDesription = description == ""
        DispatchQueue.main.async {
            self.messageTitleLabel.stringValue = title
            self.messageDescriptionLabel.stringValue = description
            self.messageStackView.isHidden = false
            if self.messageDescriptionLabel.isHidden != hideDesription {
                self.messageDescriptionLabel.isHidden = hideDesription
            }
            self.timer = Timer.scheduledTimer(withTimeInterval: 7.0, repeats: false) { timer in
                self.messageStackView.isHidden = true
            }
        }
    }
    
    
}

