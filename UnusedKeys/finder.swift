//
//  finder.swift
//  UnusedKeys
//
//  Created by Assylbek Issatayev on 08/06/2021.
//

import Foundation

final class Finder {
    private let fileManager = FileManager.default

    func mergeAllSourceCodeIn(_ directories: [String], extensions: [String]) -> String {
        let sourceFiles = findFilesIn(directories, withExtensions: extensions)
        return sourceFiles.reduce("") { (accumulator, sourceFile) -> String in
            return accumulator + contentsOfFile(sourceFile)
        }
    }

    func findFilesIn(
        _ directories: [String],
        withExtensions extensions: [String],
        filter: String? = .none
    ) -> [String] {
        var files: [String] = []
        for directory in directories {
            guard let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: directory) else {
                print("🔴 Failed to create enumerator for directory: \(directory)")
                exit(-1)
            }
            while let path = enumerator.nextObject() as? String {
                let fileExtension = (path as NSString).pathExtension.lowercased()
                if extensions.contains(fileExtension) {
                    let fullPath = (directory as NSString).appendingPathComponent(path)
                    if let filter = filter {
                        if fullPath.contains(filter) {
                            files.append(fullPath)
                        }
                    } else {
                        files.append(fullPath)
                    }
                }
            }
        }
        return files
    }

    func contentsOfFile(_ filePath: String) -> String {
        do {
            return try String(contentsOfFile: filePath)
        }
        catch {
            print("🔴 Failed to read contents of file: \(error.localizedDescription)")
            return ""
        }
    }
}
