//
//  UCLKit.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 01/03/2017.
//  Copyright © 2017 Tiago Ferreira. All rights reserved.
//

import Foundation
import RequestKit

public let UCLKitErrorDomain = "com.tiferrei.UCLKit"
public let UCLKitErrorKey = RequestKitErrorKey

// Main UCLKit Response Wrapper
public protocol UCLResponse: Codable {
    var OK: Bool? { get }
    var error: String? { get }
}

/// Main UCLKit wrapping struct
public struct UCLKit {
    public let configuration: Configuration

    public init(_ config: Configuration = TokenConfiguration()) {
        configuration = config
    }
}
