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

public struct TanukiKit {
    public let configuration: Configuration

    public init(_ config: Configuration = TokenConfiguration()) {
        configuration = config
    }
}
