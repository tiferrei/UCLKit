//
//  DecodableToDictionary.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 11/04/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import Foundation

 extension Encodable {
    /**
     - Parses a Codable object into a `[String: Any]` dictionary.
     - ⚠️: This method will return the data using **UCL API's original keys**.
     - The reason for a `[String: Any]` is that this method is meant mainly to display raw UCL API data.
     - returns: A `[String: Any]` dictionary representing the object's data.
     */
    public func toDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        } else {
            encoder.dateEncodingStrategy = .deferredToDate
        }
        do {
            let data = try encoder.encode(self)
            if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return dict
            }
        } catch {
            return ["error": "UCLKit failed to encode object."]
        }
        return ["error": "UCLKit failed to encode object."]
    }
}
