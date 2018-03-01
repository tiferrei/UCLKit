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

    func testFailedAuth() {
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/rooms?capacity=&classification=&roomid=&roomname=&siteid=&sitename=&token=InvalidToken", expectedHTTPMethod: "GET", jsonFile: "InvalidToken", statusCode: 400)
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
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/rooms?capacity=&classification=&roomid=&roomname=&siteid=&sitename=&token=", expectedHTTPMethod: "GET", jsonFile: "NoToken", statusCode: 400)
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
