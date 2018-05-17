//
//  FreeRoomsTests.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 17/05/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import XCTest
import Foundation
import RequestKit
@testable import UCLKit

class FreeRoomsTests: XCTestCase {
    static var allTests = [
        ("testGetFreeRooms", testGetFreeRooms),
        ("testFailToGetFreeRooms", testFailToGetFreeRooms),
        ("testFreeRoomsParsing", testFreeRoomsParsing),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]

    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        let darwinCount = thisClass.defaultTestSuite.testCaseCount
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }

    // MARK: Request Tests

    func testGetFreeRooms() {
        let sessionURL = "https://uclapi.com/roombookings/freerooms?end_datetime=2011-03-06T04%3A36%3A45%2B00%3A00&start_datetime=2011-03-06T03%3A36%3A45%2B00%3A00&token=12345"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .FreeRooms, statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).freeRooms(session, startDateTime: "2011-03-06T03:36:45+00:00", endDateTime: "2011-03-06T04:36:45+00:00") { response in
            switch response {
            case .success(let response):
                XCTAssertEqual(response.OK, true)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetFreeRooms() {
        let sessionURL = "https://uclapi.com/roombookings/freerooms?end_datetime=&start_datetime=&token=12345"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .FreeRooms, statusCode: 400)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).freeRooms(session, startDateTime: "", endDateTime: "") { response in
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

    func testFreeRoomsParsing() {
        let response = Helper.codableFromResource(.FreeRooms, type: FreeRoomsResponse.self)
        XCTAssertEqual(response.OK, true)
        XCTAssertEqual(response.freeRooms![0].roomName, "Wilkins Building (Main Building) Portico")
        XCTAssertEqual(response.freeRooms![0].roomID, "Z4")
        XCTAssertEqual(response.freeRooms![0].siteID, "005")
        XCTAssertEqual(response.freeRooms![0].siteName, "Main Building")
        XCTAssertEqual(response.freeRooms![0].capacity, 50)
        XCTAssertEqual(response.freeRooms![0].classification, Classification.SocialSpace)
        XCTAssertEqual(response.freeRooms![0].automated, Automation.NotAutomated)
        XCTAssertEqual(response.freeRooms![0].location!.address!, ["Gower Street", "London", "WC1E 6BT", ""])
        XCTAssertEqual(response.freeRooms![0].location!.coordinates!.latitude!, "51.524699")
        XCTAssertEqual(response.freeRooms![0].location!.coordinates!.longitude!, "-0.13366")
    }

}
