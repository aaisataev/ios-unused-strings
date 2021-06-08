//
//  extensions.swift
//  UnusedKeys
//
//  Created by Assylbek Issatayev on 08/06/2021.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    func lowercasingFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
}

extension Character {
    var isInt: Bool {
        return Int(String(self)) != nil
    }
}
