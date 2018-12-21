//
//  TSV.swift
//  LocalizedStringsUtil
//
//  Created by Mikhail on 01/12/2018.
//  Copyright © 2018 glvrzzz. All rights reserved.
//

import Foundation

class TSV {
    
    enum Error: Swift.Error {
        case invalidHeader(header: String)
        case invalidBundleName(name: String)
        case invalidTSV(fileURL: URL)
        case invalidStringsFile(fileURL: URL)
    }
    
    var bundleNamesByHeader: [String : String] = [
        "ENG" : "en",
        "CHI" : "zh-Hans",
        "FRE" : "fr",
        "SPA" : "es",
        "GER" : "de",
        "ITA" : "it",
        "SPA LATIN AMERIKA" : "es-419",
        "KOR" : "ko",
        "JAP" : "ja",
        "DUT" : "nl",
        "POR" : "pt-BR",
        "RUS" : "ru-RU",
        "ARA" : "ar",
        ]
    
    let fileManager: FileManager
    var valueSeparator: String = "\t"
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func bundleName(for header: String) -> String? {
        return bundleNamesByHeader[header]
    }
    
    func readTSV(at fileURL: URL) throws -> [[String]] {
        return try String(contentsOf: fileURL)
            .components(separatedBy: CharacterSet.newlines)
            .map {
                $0.components(separatedBy: valueSeparator).map {
                    $0.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                }
        }
    }
    
    func readFile(at fileURL: URL, tableName: String? = nil) throws -> [LanguageBundle] {
        
        let tsv = try readTSV(at: fileURL)
        
        guard
            tsv.count > 1,
            let headers = tsv.first,
            headers.count > 1
            else {
                throw Error.invalidTSV(fileURL: fileURL)
        }
        
        let tableName = tableName ?? fileURL.deletingPathExtension().lastPathComponent
        var bundles: [LanguageBundle] = []
        
        for colIndex in 1..<headers.count {
            let header = headers[colIndex]
            guard let bundleName = self.bundleName(for: header) else {
                throw Error.invalidHeader(header: header)
            }
            
            let table = Table(name: tableName)
            let bundle = LanguageBundle(name: bundleName, tables: [table])
            
            for rowIndex in 1..<tsv.count {
                let row = tsv[rowIndex]
                
                guard row.count > 1 else {
                    continue
                }
                
                let key = row[0]
                let value = row[colIndex]
                table.setStringValue(value, forKey: key)
            }
            
            bundles.append(bundle)
        }
        
        return bundles
    }
    
    func generateTemplate(fromTableAt fileURL: URL, bundleName: String = "en") throws -> String {
        
        var headers = bundleNamesByHeader.keys.sorted()
        
        guard let strings = NSDictionary(contentsOf: fileURL) as? [String : String] else {
            throw Error.invalidStringsFile(fileURL: fileURL)
        }
        
        guard
            let entry = bundleNamesByHeader.first(where: { $0.value == bundleName } ),
            let headerIndex = headers.index(of: entry.key)
            else {
                throw Error.invalidBundleName(name: bundleName)
        }
        
        let header = headers.remove(at: headerIndex)
        headers.insert(header, at: 0)
        headers.insert("", at: 0)
        
        let rows: [[String]] = [headers] + strings.map { (entry) -> [String] in
            return [entry.key, entry.value]
        }
        
        let tsv = rows.map { $0.joined(separator: valueSeparator) }.joined(separator: "\n")
        
        return tsv
    }
    
}
