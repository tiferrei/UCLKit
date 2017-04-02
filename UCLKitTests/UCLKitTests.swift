//
//  UCLKitTests.swift
//  UCLKitTests
//
//  Created by Tiago Ferreira on 01/03/2017.
//  Copyright © 2017 Tiago Ferreira. All rights reserved.
//

import XCTest
import Foundation
@testable import UCLKit

private let baseURL = "https://uclapi.com/"

class UCLKitTests: XCTestCase {

    func testConfiguration() {
        let subject = TokenConfiguration("12345")
        XCTAssertEqual(subject.accessToken!, "12345")
        XCTAssertEqual(subject.apiEndpoint, baseURL)
    }

}
