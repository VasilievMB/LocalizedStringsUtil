//
//  Data+Append.swift
//  LocalizedStringsUtil
//
//  Created by Mikhail on 01/12/2018.
//  Copyright © 2018 glvrzzz. All rights reserved.
//

import Foundation

extension Data {
    
    func append(toFileAt fileURL: URL) throws {
        
        let handle = try FileHandle(forWritingTo: fileURL)
        defer {
            handle.closeFile()
        }
        
        handle.seekToEndOfFile()
        handle.write(self)
        
    }
    
}
