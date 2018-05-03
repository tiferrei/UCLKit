//
//  ErrorHandling.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 12/03/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import Foundation

// Mark: Model

@objc open class UCLError: NSObject, Codable {
    open var OK: Bool?
    open var error: String?

    enum CodingKeys: String, CodingKey {
        case OK = "ok"
        case error
    }
}

public extension UCLKit {
    /**
     Parses an UCL API error message from userInfo in NSError.
     - parameter error: The error returned by UCLKit.
     */
    public func parseError(_ error: NSError) -> String {
        var message = ""
        if let errorResponse = error.userInfo[UCLKitErrorKey] as? [String: Any],
        let errorString = errorResponse["error"] as? String {
            message = errorString
        }
        return message
    }
}
