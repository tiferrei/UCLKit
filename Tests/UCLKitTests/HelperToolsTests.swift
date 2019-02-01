//
//  HelperToolsTests.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 26/04/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import Foundation

import XCTest
import Foundation
@testable import UCLKit

class HelperToolsTests: XCTestCase {
    static var allTests = [
        ("testRoomsDictionaryParsing", testRoomsDictionaryParsing),
        ("testBookingDictionaryParsing", testBookingDictionaryParsing),
        ("testEquipmentDictionaryParsing", testEquipmentDictionaryParsing),
        ("testSearchDictionaryParsing", testSearchDictionaryParsing),
        ("testErrorParsing", testErrorParsing),
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

    // MARK: Parsing Tests

    func testRoomsDictionaryParsing() {
        let data = Helper.codableFromResource(.Rooms, type: RoomsResponse.self).toDictionary()
        if let rooms = data["rooms"] as? [Any], let room = rooms[0] as? [String: Any] {
            XCTAssertEqual(data["ok"] as? Bool, true)
            XCTAssertEqual(room["roomid"] as? String, "Z4")
            XCTAssertEqual(room["siteid"] as? String, "005")
            XCTAssertEqual(room["sitename"] as? String, "Main Building")
            XCTAssertEqual(room["capacity"] as? Int, 50)
            XCTAssertEqual(room["classification"] as? String, Classification.SocialSpace.rawValue)
            XCTAssertEqual(room["automated"] as? String, Automation.NotAutomated.rawValue)
            if let location = room["location"] as? [String: Any] {
                XCTAssertEqual(location["address"] as? [String], ["Gower Street", "London", "WC1E 6BT", ""])
                if let coordinates = location["coordinates"] as? [String: Any] {
                    XCTAssertEqual(coordinates["lat"] as? String, "51.524699")
                    XCTAssertEqual(coordinates["lng"] as? String, "-0.13366")
                } else {
                    XCTAssert(false, "Unable to cast Coordinate.")
                }
            } else {
                XCTAssert(false, "Unable to cast Location.")
            }
        } else {
            XCTAssert(false, "Unable to cast essential data.")
        }
    }

    func testBookingDictionaryParsing() {
        let data = Helper.codableFromResource(.Bookings, type: BookingsResponse.self).toDictionary()
        if let bookings = data["bookings"] as? [Any], let booking = bookings[0] as? [String: Any] {
            XCTAssertEqual(data["ok"] as? Bool, true)
            XCTAssertEqual(booking["slotid"] as? Int, 998503)
            if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
                XCTAssertEqual(booking["start_time"] as? String, "2016-09-02T09:00:00Z")
                XCTAssertEqual(booking["end_time"] as? String, "2016-09-02T18:00:00Z")
            } else {
                XCTAssertEqual(booking["start_time"] as? Int, 494499600)
                XCTAssertEqual(booking["end_time"] as? Int, 494532000)
            }
            XCTAssertEqual(booking["description"] as? String, "split weeks to assist rooming 29.06")
            XCTAssertEqual(booking["roomname"] as? String, "Torrington (1-19) 433")
            XCTAssertEqual(booking["siteid"] as? String, "086")
            XCTAssertEqual(booking["contact"] as? String, "Ms Leah Markwick")
            XCTAssertEqual(booking["weeknumber"] as? Int, 1)
            XCTAssertEqual(booking["roomid"] as? String, "433")
            XCTAssertEqual(booking["phone"] as? String, "45699")
            XCTAssertEqual(data["next_page_exists"] as? Bool, true)
            XCTAssertEqual(data["page_token"] as? String, "6hb14hXjRV")
            XCTAssertEqual(data["count"] as? Int, 1197)
        } else {
            XCTAssert(false, "Unable to cast essential data.")
        }
    }

    func testEquipmentDictionaryParsing() {
        let data = Helper.codableFromResource(.Equipment, type: EquipmentResponse.self).toDictionary()
        if let equipmentList = data["equipment"] as? [Any] {
            XCTAssertEqual(data["ok"] as? Bool, true)
            if let equipment = equipmentList[0] as? [String: Any] {
                XCTAssertEqual(equipment["type"] as? String, Type.FixedFeature.rawValue)
                XCTAssertEqual(equipment["description"] as? String, "Managed PC")
                XCTAssertEqual(equipment["units"] as? Int, 1)
            } else {
                XCTAssert(false, "Unable to cast first equipment.")
            }
            if let equipment = equipmentList[1] as? [String: Any] {
                XCTAssertEqual(equipment["type"] as? String, Type.FixedEquipment.rawValue)
                XCTAssertEqual(equipment["description"] as? String, "Chairs with Tables")
                XCTAssertEqual(equipment["units"] as? Int, 1)
            } else {
                XCTAssert(false, "Unable to cast second equipment.")
            }
        } else {
            XCTAssert(false, "Unable to cast essential data.")
        }
    }

    func testSearchDictionaryParsing() {
        let data = Helper.codableFromResource(.People, type: PeopleResponse.self).toDictionary()
        if let people = data["people"] as? [Any], let person = people[0] as? [String: Any] {
            XCTAssertEqual(data["ok"] as? Bool, true)
            XCTAssertEqual(person["name"] as? String, "Jane Doe")
            XCTAssertEqual(person["status"] as? String, Status.Student.rawValue)
            XCTAssertEqual(person["department"] as? String, "Dept of Med Phys & Biomedical Eng")
            XCTAssertEqual(person["email"] as? String, "jane.doe.17@ucl.ac.uk")
        } else {
            XCTAssert(false, "Unable to cast essential data.")
        }
    }

    func testErrorParsing() {
        let sessionURL = "https://uclapi.com/roombookings/rooms?capacity=&classification=&roomid=&roomname=&siteid=&sitename=&token=invalidToken"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .InvalidToken, statusCode: 400)
        let config = TokenConfiguration("invalidToken")
        _ = UCLKit(config).rooms(session) { response in
            switch response {
            case .success(let data):
                XCTAssert(false, "Should retrieve an error, instead got –> (\(data))")
            case .failure(let error):
                XCTAssertEqual(UCLKit(config).parseError(error), "Token is invalid.")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }
}
