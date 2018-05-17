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
    static var allTests = [
        ("testConfiguration", testConfiguration),
        ("testFailedAuth", testFailedAuth),
        ("testMissingAuth", testMissingAuth),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]

    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let thisClass = type(of: self)
            let linuxCount = thisClass.allTests.count
            let darwinCount = thisClass.defaultTestSuite.tests.count
            XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }

    func testConfiguration() {
        let subject = TokenConfiguration("12345")
        XCTAssertEqual(subject.accessToken!, "12345")
        XCTAssertEqual(subject.apiEndpoint, baseURL)
    }

    func testFailedAuth() {
    let sessionURL = "https://uclapi.com/roombookings/rooms?capacity=&classification=&roomid=&roomname=&siteid=&sitename=&token=InvalidToken"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .InvalidToken, statusCode: 400)
        let config = TokenConfiguration("InvalidToken")
        _ = UCLKit(config).rooms(session) { response in
            switch response {
            case .success(let response):
                XCTAssert(false, "❌ Should retrieve an error –> (\(response))")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 400)
                XCTAssertEqual(error.domain, UCLKitErrorDomain)
            default:
                XCTAssert(false, "❌ Should retreive either fail or success")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testMissingAuth() {
    let sessionURL = "https://uclapi.com/roombookings/rooms?capacity=&classification=&roomid=&roomname=&siteid=&sitename=&token="
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .NoToken, statusCode: 400)
        let config = TokenConfiguration("")
        _ = UCLKit(config).rooms(session) { response in
            switch response {
            case .success(let response):
                XCTAssert(false, "❌ Should retrieve an error –> (\(response))")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 400)
                XCTAssertEqual(error.domain, UCLKitErrorDomain)
            default:
                XCTAssert(false, "❌ Should retreive either fail or success")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }
}
