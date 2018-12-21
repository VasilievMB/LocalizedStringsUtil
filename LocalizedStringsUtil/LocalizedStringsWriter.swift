//
//  LocalizedStringsWriter.swift
//  LocalizedStringsUtil
//
//  Created by Mikhail on 01/12/2018.
//  Copyright © 2018 glvrzzz. All rights reserved.
//

import Foundation

class LocalizedStringsWriter {
    
    enum Error: Swift.Error {
        case tableEncodingFailed
    }
    
    let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func write(bundle: LanguageBundle, to url: URL, overwrite: Bool = false) throws {
        let bundleURL = url
            .appendingPathComponent(bundle.name)
            .appendingPathExtension(LanguageBundle.pathExtension)
        if !fileManager.fileExists(atPath: bundleURL.path) {
            try fileManager.createDirectory(at: bundleURL, withIntermediateDirectories: true, attributes: nil)
        }
        try bundle.tables.forEach { (table) in
            try write(table: table, to: bundleURL, overwrite: overwrite)
        }
    }
    
    func write(table: Table, to url: URL, overwrite: Bool = false) throws {
        let fileURL = url
            .appendingPathComponent(table.name)
            .appendingPathExtension(Table.pathExtension)
        
        guard let data = table.description.data(using: .utf8,
                                                allowLossyConversion: false) else {
            throw Error.tableEncodingFailed
        }
        
        if !overwrite && fileManager.fileExists(atPath: fileURL.path) {
            try data.append(toFileAt: fileURL)
        } else {
            try data.write(to: fileURL)
        }
    }
    
    func write(bundles: [LanguageBundle], to url: URL, overwrite: Bool = false) throws {
        try bundles.forEach { (bundle) in
            try write(bundle: bundle, to: url, overwrite: overwrite)
        }
    }
    
}
