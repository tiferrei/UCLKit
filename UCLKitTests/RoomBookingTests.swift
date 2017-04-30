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

    func testGetBookings() {
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/bookings?access_token=12345&contact=&date=&description=&end_datetime=&page_token=&results_per_page=1000&roomid=&roomname=&siteid=&start_datetime=", expectedHTTPMethod: "GET", jsonFile: "Bookings", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).bookings(session) { response in
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
    
    func testGetBookingsWithParams() {
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/bookings?access_token=12345&contact=Mark%20Herbster&date=20160202&description=Lecture&end_datetime=2016-10-20T19%3A00%3A00%2B00%3A00&page_token=&results_per_page=1000&roomid=433&roomname=Cruciform%20Building%20B.3.05&siteid=086&start_datetime=2016-10-20T18%3A00%3A00%2B00%3A00", expectedHTTPMethod: "GET", jsonFile: "Bookings", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).bookings(session, roomName: "Cruciform Building B.3.05", roomID: "433", startDateTime: "2016-10-20T18:00:00+00:00", endDateTime: "2016-10-20T19:00:00+00:00", date: "20160202", siteID: "086", description: "Lecture", contact: "Mark Herbster", resultsPerPage: "1000") { response in
            switch response {
            case .success(let response):
                XCTAssertEqual(response.OK, true)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }
    
    func testGetPaginatedBookings() {
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/bookings?access_token=12345&contact=&date=&description=&end_datetime=&page_token=6hb14hXjRV&results_per_page=1000&roomid=&roomname=&siteid=&start_datetime=", expectedHTTPMethod: "GET", jsonFile: "Bookings", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).bookings(session, pageToken: "6hb14hXjRV") { response in
            switch response {
            case .success(let response):
                XCTAssertEqual(response.OK, true)
                XCTAssertEqual(response.pageToken, "6hb14hXjRV")
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }
    
    // MARK: Model Tests
    
    func testRoomsParsing() {
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
    
    func testBookingsParsing() {
        let response = BookingsResponse(TestHelper.JSONFromFile(name: "Bookings") as! [String: AnyObject])
        XCTAssertEqual(response.OK, true)
        XCTAssertEqual(response.bookings![0].slotID, 998503)
        XCTAssertEqual(response.bookings![0].endTime, UCLKit.Time.parseString(string: "2016-09-02T18:00:00+00:00"))
        XCTAssertEqual(response.bookings![0].bookingDescription, "split weeks to assist rooming 29.06")
        XCTAssertEqual(response.bookings![0].roomName, "Torrington (1-19) 433")
        XCTAssertEqual(response.bookings![0].siteID, "086")
        XCTAssertEqual(response.bookings![0].contact, "Ms Leah Markwick")
        XCTAssertEqual(response.bookings![0].weekNumber, 1)
        XCTAssertEqual(response.bookings![0].roomID, "433")
        XCTAssertEqual(response.bookings![0].startTime, UCLKit.Time.parseString(string: "2016-09-02T09:00:00+00:00"))
        XCTAssertEqual(response.bookings![0].phone, "45699")
        XCTAssertEqual(response.nextPageExists, true)
        XCTAssertEqual(response.pageToken, "6hb14hXjRV")
        XCTAssertEqual(response.count, 1197)
    }
}
