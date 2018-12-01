//
//  LocalizedStringsReader.swift
//  LocalizedStringsUtil
//
//  Created by Mikhail on 01/12/2018.
//  Copyright © 2018 glvrzzz. All rights reserved.
//

import Foundation

class LocalizedStringsReader {
    
    enum Error: Swift.Error {
        case invalidStringsTableFile(fileURL: URL)
    }
    
    let fileManager: FileManager
    var stringsSort: StringsSort?
    
    init(fileManager: FileManager = FileManager.default,
         stringsSort: StringsSort? = nil) {
        self.fileManager = fileManager
        self.stringsSort = stringsSort
    }
    
    func readTable(at url: URL) throws -> Table {
        let tableName = url.deletingPathExtension().lastPathComponent
        
        guard let stringsDictionary = NSDictionary(contentsOf: url) as? [String : String] else {
            throw Error.invalidStringsTableFile(fileURL: url)
        }
        
        var strings = stringsDictionary.map { (entry) -> LocalizedString in
            return LocalizedString(key: entry.key, value: entry.value)
        }
        
        if let sort = stringsSort {
            strings = try strings.sorted(by: sort)
        }
        
        return Table(name: tableName, strings: strings)
    }
    
    func readBundle(at url: URL) throws -> LanguageBundle {
        
        let name = url.deletingPathExtension().lastPathComponent
        
        let directoryContents = try fileManager
            .contentsOfDirectory(at: url,
                                 includingPropertiesForKeys: nil,
                                 options: .skipsHiddenFiles)
            .filter {
                $0.pathExtension == Table.pathExtension
        }
        
        let tables = try directoryContents.map { url in
            return try readTable(at: url)
        }
        
        return LanguageBundle(name: name, tables: tables)
    }
    
    func readBundles(at url: URL) throws -> [LanguageBundle] {
        
        let contents = try fileManager
            .contentsOfDirectory(at: url,
                                 includingPropertiesForKeys: nil,
                                 options: .skipsHiddenFiles)
            .filter {
                $0.pathExtension == LanguageBundle.pathExtension
        }
        
        return try contents.map { url in
            return try readBundle(at: url)
        }
    }
    
}
