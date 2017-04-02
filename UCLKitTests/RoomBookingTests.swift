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
    
    func testGetRooms() {
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/rooms?token=12345", expectedHTTPMethod: "GET", jsonFile: "Rooms", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).rooms(session) { response in
            switch response {
            case .success(let results):
                XCTAssertEqual(results.OK, true)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetRoomsWithParams() {
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/rooms?token=12345?roomid=?", expectedHTTPMethod: "GET", jsonFile: "Rooms", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).rooms(session, roomID: "123", roomName: "NAME", siteID: "123", siteName: "NAME", classification: Classification.All, capacity: "123") { response in
            switch response {
            case .success(let results):
                XCTAssertEqual(results.OK, true)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }


}
