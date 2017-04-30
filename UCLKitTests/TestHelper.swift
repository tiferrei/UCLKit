//
//  TestHelper.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 04/03/2017.
//  Copyright © 2017 Piet Brauer & Tiago Ferreira. All rights reserved.
//

import Foundation

internal class TestHelper {
    internal class func stringFromFile(_ name: String) -> String? {
        let bundle = Bundle(for: self)
        let path = bundle.path(forResource: name, ofType: "json")
        if let path = path {
            let string = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return string
        }
        return nil
    }

    internal class func JSONFromFile(name: String) -> Any {
        let bundle = Bundle(for: self)
        let path = bundle.url(forResource: name, withExtension: "json")!
        let data = try! Data(contentsOf: path)
        let dict: Any? = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        return dict!
    }
}
