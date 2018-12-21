//
//  main.swift
//  LocalizedStringsUtil
//
//  Created by Mikhail on 01/12/2018.
//  Copyright © 2018 glvrzzz. All rights reserved.
//

import Foundation

do {
    let tsv = TSV()
    
    //let stringsURL = URL(fileURLWithPath: "/Users/Mikhail/tmp/Fax/strings/NotificationsAccessDenied.strings")
    //let template = try! tsv.generateTemplate(fromTableAt: stringsURL)
    //let outputURL = URL(fileURLWithPath: "/Users/Mikhail/tmp/Fax/strings", isDirectory: true)
    //    .appendingPathComponent("NotificationsAccessDenied.tsv")
    //try! template.write(to: outputURL, atomically: true, encoding: .utf8)
    
    ///Users/Mikhail/tmp/Fax/strings/NotificationsAccessDenied-FaxSent.tsv
    let tsvURL = URL(fileURLWithPath: "/Users/Mikhail/tmp/Fax/strings/NotificationsAccessDenied-FaxSent.tsv")
    let bundles = try tsv.readFile(at: tsvURL, tableName: "DeliveryCheck")
    let writer = LocalizedStringsWriter()
    let outputURL = URL(fileURLWithPath: "/Users/Mikhail/Projects/Scanner/Fax/Modules/DeliveryCheck/View/Strings", isDirectory: true)
    try writer.write(bundles: bundles, to: outputURL, overwrite: false)
    
    
//    let tsvURL = URL(fileURLWithPath: "/Users/Mikhail/tmp/Fax/strings/NotificationsAccessDenied.tsv")
//    let bundles = try tsv.readFile(at: tsvURL, tableName: "NotificationsAccessDenied")
//    let writer = LocalizedStringsWriter()
//    let outputURL = URL(fileURLWithPath: "/Users/Mikhail/Projects/Scanner/Fax/Modules/NotificationsAccessDenied/View/Strings", isDirectory: true)
//    try writer.write(bundles: bundles, to: outputURL, overwrite: true)
} catch let error {
    print(error.localizedDescription)
}

print("done")
