//
//  RoomBookingTests.swift
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
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/rooms?capacity=&classification=&roomid=&roomname=&siteid=&sitename=&token=12345", expectedHTTPMethod: "GET", jsonFile: "Rooms", statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).rooms(session) { response in
            switch response {
            case .success(let response):
                XCTAssertEqual(response.OK, true)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetRoomsWithParams() {
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/rooms?capacity=123&classification=&roomid=123&roomname=NAME&siteid=123&sitename=NAME&token=12345", expectedHTTPMethod: "GET", jsonFile: "Rooms", statusCode: 200)
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

    func testFailToGetRooms() {
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/rooms?capacity=&classification=&roomid=&roomname=&siteid=&sitename=&token=invalidToken", expectedHTTPMethod: "GET", jsonFile: "InvalidToken", statusCode: 400)
        let config = TokenConfiguration("invalidToken")
        _ = UCLKit(config).rooms(session) { response in
            switch response {
            case .success(let rooms):
                XCTAssert(false, "❌ Should retrieve an error, instead got –> (\(rooms))")
            case .failure(let error as NSError):
                var json = error.userInfo[RequestKitErrorKey]! as? [String: Any]
                XCTAssertEqual(json!["error"] as? String, "Token is invalid.")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests

    func testRoomsParsing() {
        let response = Helper.codableFromFile("Rooms", type: RoomsResponse.self)
        XCTAssertEqual(response.OK, true)
        XCTAssertEqual(response.rooms![0].roomName, "Wilkins Building (Main Building) Portico")
        XCTAssertEqual(response.rooms![0].roomID, "Z4")
        XCTAssertEqual(response.rooms![0].siteID, "005")
        XCTAssertEqual(response.rooms![0].siteName, "Main Building")
        XCTAssertEqual(response.rooms![0].capacity, 50)
        XCTAssertEqual(response.rooms![0].classification, Classification.SocialSpace)
        XCTAssertEqual(response.rooms![0].automated, Automation.NotAutomated)
        XCTAssertEqual(response.rooms![0].location!.address!, ["Gower Street", "London", "WC1E 6BT", ""])
        XCTAssertEqual(response.rooms![0].location!.coordinates!.latitude!, "51.524699")
        XCTAssertEqual(response.rooms![0].location!.coordinates!.longitude!, "-0.13366")
    }

}

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
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/bookings?contact=&date=&description=&end_datetime=&page_token=&results_per_page=1000&roomid=&roomname=&siteid=&start_datetime=&token=12345", expectedHTTPMethod: "GET", jsonFile: "Bookings", statusCode: 200)
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
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/bookings?contact=&date=&description=&end_datetime=&page_token=&results_per_page=1000&roomid=&roomname=&siteid=&start_datetime=&token=12345", expectedHTTPMethod: "GET", jsonFile: "Bookings", statusCode: 400)
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
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/bookings?contact=Mark%20Herbster&date=20160202&description=Lecture&end_datetime=2016-10-20T19%3A00%3A00%2B00%3A00&page_token=&results_per_page=1000&roomid=433&roomname=Cruciform%20Building%20B.3.05&siteid=086&start_datetime=2016-10-20T18%3A00%3A00%2B00%3A00&token=12345", expectedHTTPMethod: "GET", jsonFile: "Bookings", statusCode: 200)
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
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/bookings?contact=&date=&description=&end_datetime=&page_token=6hb14hXjRV&results_per_page=1000&roomid=&roomname=&siteid=&start_datetime=&token=12345", expectedHTTPMethod: "GET", jsonFile: "Bookings", statusCode: 200)
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
        let response = Helper.codableFromFile("Bookings", type: BookingsResponse.self)
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
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/equipment?roomid=433&siteid=086&token=12345", expectedHTTPMethod: "GET", jsonFile: "Equipment", statusCode: 200)
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
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/equipment?roomid=&siteid=&token=12345", expectedHTTPMethod: "GET", jsonFile: "Equipment", statusCode: 400)
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
        let response = Helper.codableFromFile("Equipment", type: EquipmentResponse.self)
        XCTAssertEqual(response.OK, true)
        XCTAssertEqual(response.equipment![0].type, Type.FixedFeature)
        XCTAssertEqual(response.equipment![0].equipmentDescription, "Managed PC")
        XCTAssertEqual(response.equipment![0].units, 1)
        XCTAssertEqual(response.equipment![1].type, Type.FixedEquipment)
        XCTAssertEqual(response.equipment![1].equipmentDescription, "Chairs with Tables")
        XCTAssertEqual(response.equipment![1].units, 1)
    }

}

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
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/freerooms?end_datetime=2011-03-06T04%3A36%3A45%2B00%3A00&start_datetime=2011-03-06T03%3A36%3A45%2B00%3A00&token=12345", expectedHTTPMethod: "GET", jsonFile: "FreeRooms", statusCode: 200)
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
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/freerooms?end_datetime=&start_datetime=&token=12345", expectedHTTPMethod: "GET", jsonFile: "FreeRooms", statusCode: 400)
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
        let response = Helper.codableFromFile("FreeRooms", type: FreeRoomsResponse.self)
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
