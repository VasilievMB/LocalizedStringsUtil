//
//  Table.swift
//  LocalizedStringsUtil
//
//  Created by Mikhail on 01/12/2018.
//  Copyright © 2018 glvrzzz. All rights reserved.
//

import Foundation

typealias StringsSort = ((LocalizedString, LocalizedString) throws -> Bool)

class Table: CustomStringConvertible {
    
    let name: String
    
    init(name: String, strings: [LocalizedString] = []) {
        self.name = name
        self.strings = strings
    }
    
    private (set) var strings: [LocalizedString]
    
    static let pathExtension = "strings"
    
    var description: String {
        return strings.map { $0.description }.joined(separator: "\n\n")
    }
    
    func string(withKey key: String) -> LocalizedString? {
        return strings.first(where: { $0.key == key })
    }
    
    func setStringValue(_ value: String, forKey key: String) {
        if let string = self.string(withKey: key) {
            string.value = value
        } else {
            let string = LocalizedString(key: key, value: value)
            strings.append(string)
        }
    }
    
    func sortStrings(by areInIncreasingOrder: StringsSort) rethrows {
        strings = try strings.sorted(by: areInIncreasingOrder)
    }
    
    @discardableResult func removeString(withKey key: String) -> LocalizedString? {
        if let index = strings.index(where: { $0.key == key } ) {
            return strings.remove(at: index)
        } else {
            return nil
        }
    }

}
