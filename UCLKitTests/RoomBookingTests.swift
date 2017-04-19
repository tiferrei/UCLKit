//
//  RoomBookingTests.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 04/03/2017.
//  Copyright © 2017 Tiago Ferreira. All rights reserved.
//

import XCTest
import Foundation
@testable import UCLKit

class RoomBookingTests: XCTestCase {
    
    // MARK: Request Tests
    
    func testGetRooms() {
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/rooms?access_token=12345&capacity=&roomid=&roomname=&siteid=&sitename=", expectedHTTPMethod: "GET", jsonFile: "Rooms", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).rooms(session) { response in
            switch response {
            case .success(let response):
                print(response)
                XCTAssertEqual(response.OK, true)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetRoomsWithParams() {
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/rooms?access_token=12345&capacity=123&roomid=123&roomname=NAME&siteid=123&sitename=NAME", expectedHTTPMethod: "GET", jsonFile: "Rooms", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).rooms(session, roomID: "123", roomName: "NAME", siteID: "123", siteName: "NAME", classification: Classification.Unknown, capacity: "123") { response in
            switch response {
            case .success(let response):
                XCTAssertEqual(response.OK, true)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests
    
    func testProjectsParsing() {
        let response = RoomsResponse(TestHelper.JSONFromFile(name: "Rooms") as! [String: AnyObject])
        XCTAssertEqual(response.OK, true)
        XCTAssertEqual(response.rooms![0].roomName, "Wilkins Building (Main Building) Portico")
        XCTAssertEqual(response.rooms![0].roomID, "Z4")
        XCTAssertEqual(response.rooms![0].siteID, "005")
        XCTAssertEqual(response.rooms![0].siteName, "Main Building")
        XCTAssertEqual(response.rooms![0].capacity, 50)
        XCTAssertEqual(response.rooms![0].classification, Classification.SocialSpace)
        XCTAssertEqual(response.rooms![0].automated, Automation.NotAutomated)
        XCTAssertEqual(response.rooms![0].location!.address!, ["Gower Street", "London", "WC1E 6BT", ""])
    }
}
