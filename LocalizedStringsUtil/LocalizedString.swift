//
//  LocalizedString.swift
//  LocalizedStringsUtil
//
//  Created by Mikhail on 01/12/2018.
//  Copyright © 2018 glvrzzz. All rights reserved.
//

import Foundation

class LocalizedString: CustomStringConvertible {
    
    var description: String {
        return "\"\(key)\" = \"\(value)\";"
    }
    
    let key: String
    var value: String
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}
