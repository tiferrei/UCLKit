//
//  TestHelper.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 04/03/2017.
//  Copyright © 2017 Piet Brauer & Tiago Ferreira. All rights reserved.
//

import Foundation
import UCLKit

internal class Helper {
    internal class func JSONFromResource(_ resource: ResourcesManager) -> Any {
        let data = resource.rawValue.data(using: .utf8)!
        let dict: Any? = try? JSONSerialization.jsonObject(with: data,
        options: JSONSerialization.ReadingOptions.mutableContainers)
        return dict!
    }

    internal class func codableFromResource<T>(_ resource: ResourcesManager, type: T.Type) -> T where T: Codable {
        let data = resource.rawValue.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.inclusiveISO8601DateFormatter)
        return try! decoder.decode(T.self, from: data)
    }
}
