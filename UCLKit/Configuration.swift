//
//  Configuration.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 01/03/2017.
//  Copyright © 2017 Tiago Ferreira. All rights reserved.
//

import Foundation
import RequestKit

let baseURL = "https://uclapi.com/"

/// Base API and auth settings
public struct TokenConfiguration: Configuration {
    public var apiEndpoint: String
    public var accessToken: String?
    public let errorDomain = UCLKitErrorDomain

    public init(_ token: String? = nil, url: String = baseURL) {
        apiEndpoint = url
        accessToken = token
    }
}
