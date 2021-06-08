#!/usr/bin/env xcrun swift

import Foundation

let dispatchGroup = DispatchGroup()
let serialWriterQueue = DispatchQueue(label: "writer")
let globalQueue = DispatchQueue.global()
let finder = Finder()
let parser = Parser()
let formatter = Formatter()

func start(stringsDirectory: String, rootDirectories: [String]) -> [String] {
    var result: [String] = []
    let sourceCode = finder.mergeAllSourceCodeIn(rootDirectories, extensions: ["swift"])
    let stringsFiles = finder.findFilesIn([stringsDirectory], withExtensions: ["strings"], filter: "en.")

    guard let stringsFile = stringsFiles.first else {
        return result
    }

    dispatchGroup.enter()
    globalQueue.async {
        let stringsContent = finder.contentsOfFile(stringsFile)
        let unusedIdentifiers = parser.extractStringIdentifiersFrom(stringsContent).filter { identifier in
            let string = formatter.formatSwiftgenLocalizeString(key: identifier)
            return !sourceCode.contains(string)
        }

        if unusedIdentifiers.isEmpty == false {
            serialWriterQueue.async {
                result += unusedIdentifiers
                dispatchGroup.leave()
            }
        } else {
            dispatchGroup.leave()
        }
    }
    dispatchGroup.wait()

    return result
}

// MARK: - CommandLine

if CommandLine.arguments.count > 2 {
    var args = CommandLine.arguments
    args.removeFirst()
    let stringsDirectory = args.removeFirst()
    let rootDirectories = args
    let date = Date()
    print("⚪️ Starting")
    let keys = start(stringsDirectory: stringsDirectory, rootDirectories: rootDirectories)
    print("⚪️ Unused strings were detected: \(keys.count)")
    keys.sorted().forEach { print($0) }
    print("🟢 Finished in \(Int(-date.timeIntervalSinceNow)) sec")
} else {
    print("🔴 Please provide a strings directory and directories for source code files as command line arguments. Aborting")
}
