//
//  formatter.swift
//  UnusedKeys
//
//  Created by Assylbek Issatayev on 08/06/2021.
//

import Foundation

final class Formatter {
    func formatSwiftgenLocalizeString(key: String) -> String {
        let components = key.components(separatedBy: ".")
        let components2 = components.map { $0.components(separatedBy: "_") }
        var capitalized = components2.map { $0.map { $0.capitalizingFirstLetter() }.joined() }
        let lastIndex = capitalized.count - 1
        for i in 0...lastIndex {
            if capitalized[i] == capitalized[i].uppercased() {
                capitalized[i] = capitalized[i].capitalized
            }
            if capitalized[i].first?.isInt == true {
                capitalized[i] = "_" + capitalized[i]
            }
        }
        let lastWord = capitalized[lastIndex]
        capitalized[lastIndex] = lastWord.lowercasingFirstLetter()
        let joined = capitalized.joined(separator: ".")
        return joined
    }
}
