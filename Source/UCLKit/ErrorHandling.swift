//
//  ErrorHandling.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 12/03/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import Foundation

public extension UCLKit {
    /**
     Parses an UCL API error message from userInfo in NSError.
     - parameter error: The error returned by UCLKit.
     */
    public func parseError(_ error: Error) -> String {
        var message = ""
        #if os(Linux)
            if let error = error as? NSError {
                if let errorResponse = error.userInfo[UCLKitErrorKey] as? [String: String],
                    let errorString = errorResponse["error"] {
                    message = errorString
                }
            }
        #else
            if let errorResponse = (error as NSError).userInfo[UCLKitErrorKey] as? [String: String],
                let errorString = errorResponse["error"] {
                message = errorString
            }
        #endif
        return message
    }
}
