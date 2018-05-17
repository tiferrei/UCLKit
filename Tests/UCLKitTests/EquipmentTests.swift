//
//  EquipmentTests.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 17/05/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import XCTest
import Foundation
import RequestKit
@testable import UCLKit

class EquipmentTests: XCTestCase {
    static var allTests = [
        ("testGetEquipment", testGetEquipment),
        ("testFailToGetEquipment", testFailToGetEquipment),
        ("testEquipmentParsing", testEquipmentParsing),
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

    // MARK: Request Tests

    func testGetEquipment() {
        let sessionURL = "https://uclapi.com/roombookings/equipment?roomid=433&siteid=086&token=12345"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .Equipment, statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).equipment(session, roomID: "433", siteID: "086") { response in
            switch response {
            case .success(let response):
                XCTAssertEqual(response.OK, true)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetEquipment() {
        let sessionURL = "https://uclapi.com/roombookings/equipment?roomid=&siteid=&token=12345"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .Equipment, statusCode: 400)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).equipment(session, roomID: "", siteID: "") { response in
            switch response {
            case .success(let response):
                XCTAssert(false, "❌ Should not retrieve a response (\(response))")
                XCTAssertEqual(response.OK, true)
            case .failure(_):
                XCTAssert(true)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }


    // MARK: Model Tests

    func testEquipmentParsing() {
        let response = Helper.codableFromResource(.Equipment, type: EquipmentResponse.self)
        XCTAssertEqual(response.OK, true)
        XCTAssertEqual(response.equipment![0].type, Type.FixedFeature)
        XCTAssertEqual(response.equipment![0].equipmentDescription, "Managed PC")
        XCTAssertEqual(response.equipment![0].units, 1)
        XCTAssertEqual(response.equipment![1].type, Type.FixedEquipment)
        XCTAssertEqual(response.equipment![1].equipmentDescription, "Chairs with Tables")
        XCTAssertEqual(response.equipment![1].units, 1)
    }

}
