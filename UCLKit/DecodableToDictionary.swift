//
//  DecodableToDictionary.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 11/04/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import Foundation

extension Decodable {
    /**
     Parses a Decodable object into a `[String: Any]` dictionary.
     The reason for a `String: Any` is that this function is meant mainly to display raw UCL API data.
     - returns: A dictionary of `String` keys and `String` values **or** a `[String: Any]` dictionary itself that represents an inner JSON node.
     */
    public func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                if let value = child.value as? String {
                    dict[key] = value
                } else if let value = child.value as? Bool {
                    dict[key] = String(value)
                } else if let value = child.value as? Int {
                    dict[key] = String(value)
                } else if let value = child.value as? Double {
                    dict[key] = String(value)
                } else if let value = child.value as? Date {
                    dict[key] = value.description(with: Locale.current)
                } else if let value = child.value as? Type {
                    dict[key] = value.rawValue
                } else if let value = child.value as? Status {
                    dict[key] = value.rawValue
                } else if let value = child.value as? Automation {
                    dict[key] = value.rawValue
                } else if let value = child.value as? Classification {
                    dict[key] = value.rawValue
                } else if let value = child.value as? Location {
                    dict[key] = value.toDictionary()
                } else if let value = child.value as? Coordinate {
                    dict[key] = value.toDictionary()
                } else if let value = child.value as? Decodable {
                    dict[key] = value.toDictionary()
                } else if let value = child.value as? Array<String> {
                    dict[key] = value.filter { $0 != "" }.joined(separator: ", ")
                } else if let value = child.value as? Array<Decodable> {
                    var array = Array<[String: Any]>()
                    for item in (value as Array<Decodable>) {
                        array.append(item.toDictionary())
                    }
                    dict[key] = array
                }
            }
        }
        return dict
        // FIXME: Swift runtime does not yet support dynamically querying conditional conformance.
    }
}
