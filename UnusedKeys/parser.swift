//
//  parser.swift
//  UnusedKeys
//
//  Created by Assylbek Issatayev on 08/06/2021.
//

import Foundation

final class Parser {
    private let doubleQuote = "\""

    func extractStringIdentifiersFrom(_ stringsFile: String) -> [String] {
        let identifiers = stringsFile
            .components(separatedBy: "\n")
            .map    { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
            .filter { $0.hasPrefix(doubleQuote) }
            .map    { extractStringIdentifierFromTrimmedLine($0) }
        return identifiers
    }

    func extractStringIdentifierFromTrimmedLine(_ line: String) -> String {
        let indexAfterFirstQuote = line.index(after: line.startIndex)
        let lineWithoutFirstQuote = line[indexAfterFirstQuote...]
        let endIndex = lineWithoutFirstQuote.firstIndex(of:"\"")!
        let identifier = lineWithoutFirstQuote[..<endIndex]
        return String(identifier)
    }
}
