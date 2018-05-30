//
//  RoomTests.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 04/03/2017.
//  Copyright © 2017 Tiago Ferreira. All rights reserved.
//

import XCTest
import Foundation
import RequestKit
@testable import UCLKit

class RoomTests: XCTestCase {
    static var allTests = [
        ("testGetRooms", testGetRooms),
        ("testGetRoomsWithParams", testGetRoomsWithParams),
        ("testFailToGetRooms", testFailToGetRooms),
        ("testRoomsParsing", testRoomsParsing),
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

    func testGetRooms() {
    let sessionURL = "https://uclapi.com/roombookings/rooms?capacity=&classification=&roomid=&roomname=&siteid=&sitename=&token=12345"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .Rooms, statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).rooms(session) { response in
            switch response {
            case .success(let data):
                XCTAssertEqual(data.OK, true)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetRoomsWithParams() {
        let sessionURL = "https://uclapi.com/roombookings/rooms?capacity=123&classification=&roomid=123&roomname=NAME&siteid=123&sitename=NAME&token=12345"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .Rooms, statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).rooms(session, roomID: "123", roomName: "NAME", siteID: "123", siteName: "NAME", classification: .Unknown, capacity: "123") { response in
            switch response {
            case .success(let data):
                XCTAssertEqual(data.OK, true)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetRooms() {
        let sessionURL = "https://uclapi.com/roombookings/rooms?capacity=&classification=&roomid=&roomname=&siteid=&sitename=&token=InvalidToken"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .InvalidToken, statusCode: 400)
        let config = TokenConfiguration("InvalidToken")
        _ = UCLKit(config).rooms(session) { response in
            switch response {
            case .success(let data):
                XCTAssert(false, "❌ Should retrieve an error, instead got –> (\(data))")
            case .failure(let error):
                XCTAssertEqual(UCLKit(config).parseError(error), "Token is invalid.")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests

    func testRoomsParsing() {
        let data = Helper.codableFromResource(.Rooms, type: RoomsResponse.self)
        XCTAssertEqual(data.OK, true)
        XCTAssertEqual(data.rooms![0].roomName, "Wilkins Building (Main Building) Portico")
        XCTAssertEqual(data.rooms![0].roomID, "Z4")
        XCTAssertEqual(data.rooms![0].siteID, "005")
        XCTAssertEqual(data.rooms![0].siteName, "Main Building")
        XCTAssertEqual(data.rooms![0].capacity, 50)
        XCTAssertEqual(data.rooms![0].classification, Classification.SocialSpace)
        XCTAssertEqual(data.rooms![0].classificationName, "Social Space")
        XCTAssertEqual(data.rooms![0].automated, Automation.NotAutomated)
        XCTAssertEqual(data.rooms![0].location!.address!, ["Gower Street", "London", "WC1E 6BT", ""])
        XCTAssertEqual(data.rooms![0].location!.coordinates!.latitude!, "51.524699")
        XCTAssertEqual(data.rooms![0].location!.coordinates!.longitude!, "-0.13366")
    }

}
