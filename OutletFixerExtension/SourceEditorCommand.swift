//
//  SourceEditorCommand.swift
//  OutletFixerExtension
//
//  Created by Sven Jansen on 28.08.17.
//  Copyright © 2017 Cellular GmbH. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        let sourceLines = invocation.buffer.lines
        var newSource = [Any]()
        var outletNames = [String]()
        sourceLines.forEach { (line) in
            if let string = line as? String {
                var newLine = string
                if string.contains("@IBOutlet") {
                    newLine = newLine.replacingOccurrences(of: "!", with: "?")

                    // save name of outlet for later adjustments
                    let words = newLine.components(separatedBy: " ")
                    for word in words {
                        if word.contains(":") {
                            let outletName = word.replacingOccurrences(of: ":", with: "")
                            outletNames.append(outletName)
                        }
                    }
                }
                if !newLine.contains("weak") {
                    newLine = newLine.replacingOccurrences(of: "@IBOutlet", with: "@IBOutlet weak")
                }
                if !newLine.contains("private") {
                    newLine = newLine.replacingOccurrences(of: "@IBOutlet", with: "@IBOutlet private")
                }

                for outlet in outletNames {
                    if newLine.contains("\(outlet).") {
                        newLine = newLine.replacingOccurrences(of: "\(outlet).", with: "\(outlet)?.")
                    }
                }

                newSource.append(newLine)

            } else {
                newSource.append(line)
            }
        }
        sourceLines.removeAllObjects()
        sourceLines.addObjects(from: newSource)
        completionHandler(nil)
    }
    
}
