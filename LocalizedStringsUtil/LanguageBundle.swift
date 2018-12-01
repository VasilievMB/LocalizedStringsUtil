//
//  LanguageBundle.swift
//  LocalizedStringsUtil
//
//  Created by Mikhail on 01/12/2018.
//  Copyright © 2018 glvrzzz. All rights reserved.
//

import Foundation

class LanguageBundle {
    
    let name: String
    var tables: [Table]
    
    init(name: String, tables: [Table] = []) {
        self.name = name
        self.tables = tables
    }
    
    func table(named: String) -> Table? {
        return tables.first(where: { $0.name == name })
    }
    
    static let pathExtension = "lproj"
    
    func sortStrings(by areInIncreasingOrder: StringsSort) rethrows {
        try tables.forEach { (table) in
            try table.sortStrings(by: areInIncreasingOrder)
        }
    }
    
}
