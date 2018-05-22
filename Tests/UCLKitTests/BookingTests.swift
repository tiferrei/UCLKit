//
//  BookingTests.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 17/05/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import XCTest
import Foundation
import RequestKit
@testable import UCLKit

class BookingTests: XCTestCase {
    static var allTests = [
        ("testGetBookings", testGetBookings),
        ("testFailToGetBookings", testFailToGetBookings),
        ("testGetBookingsWithParams", testGetBookingsWithParams),
        ("testGetPaginatedBookings", testGetPaginatedBookings),
        ("testBookingsParsing", testBookingsParsing),
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

    func testGetBookings() {
        let sessionURL = "https://uclapi.com/roombookings/bookings?contact=&date=&description=&end_datetime=&page_token=&results_per_page=1000&roomid=&roomname=&siteid=&start_datetime=&token=12345"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .Bookings, statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).bookings(session) { response in
            switch response {
            case .success(let response):
                XCTAssertEqual(response.OK, true)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetBookings() {
        let sessionURL = "https://uclapi.com/roombookings/bookings?contact=&date=&description=&end_datetime=&page_token=&results_per_page=1000&roomid=&roomname=&siteid=&start_datetime=&token=12345"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .Bookings, statusCode: 400)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).bookings(session) { response in
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

    func testGetBookingsWithParams() {
        let sessionURL = "https://uclapi.com/roombookings/bookings?contact=Mark%20Herbster&date=20160202&description=Lecture&end_datetime=2016-10-20T19%3A00%3A00%2B00%3A00&page_token=&results_per_page=1000&roomid=433&roomname=Cruciform%20Building%20B.3.05&siteid=086&start_datetime=2016-10-20T18%3A00%3A00%2B00%3A00&token=12345"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .Bookings, statusCode: 200)
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
        let sessionURL = "https://uclapi.com/roombookings/bookings?contact=&date=&description=&end_datetime=&page_token=6hb14hXjRV&results_per_page=1000&roomid=&roomname=&siteid=&start_datetime=&token=12345"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .Bookings, statusCode: 200)
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

    func testBookingsParsing() {
        let response = Helper.codableFromResource(.Bookings, type: BookingsResponse.self)
        XCTAssertEqual(response.OK, true)
        XCTAssertEqual(response.bookings![0].slotID, 998503)
        XCTAssertEqual(response.bookings![0].endTime, Time.iso8601Date("2016-09-02T18:00:00+00:00"))
        XCTAssertEqual(response.bookings![0].bookingDescription, "split weeks to assist rooming 29.06")
        XCTAssertEqual(response.bookings![0].roomName, "Torrington (1-19) 433")
        XCTAssertEqual(response.bookings![0].siteID, "086")
        XCTAssertEqual(response.bookings![0].contact, "Ms Leah Markwick")
        XCTAssertEqual(response.bookings![0].weekNumber, 1)
        XCTAssertEqual(response.bookings![0].roomID, "433")
        XCTAssertEqual(response.bookings![0].startTime, Time.iso8601Date("2016-09-02T09:00:00+00:00"))
        XCTAssertEqual(response.bookings![0].phone, "45699")
        XCTAssertEqual(response.nextPageExists, true)
        XCTAssertEqual(response.pageToken, "6hb14hXjRV")
        XCTAssertEqual(response.count, 1197)
    }

}
