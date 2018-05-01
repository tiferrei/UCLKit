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

    // MARK: Parsing Tests

    func testRoomsDictionaryParsing() {
        let response = Helper.codableFromFile("Rooms", type: RoomsResponse.self).toDictionary()
        if let rooms = response["rooms"] as? [Any], let room = rooms[0] as? [String: Any] {
            XCTAssertEqual(response["OK"] as? String, "true")
            XCTAssertEqual(room["roomID"] as? String, "Z4")
            XCTAssertEqual(room["siteID"] as? String, "005")
            XCTAssertEqual(room["siteName"] as? String, "Main Building")
            XCTAssertEqual(room["capacity"] as? String, "50")
            XCTAssertEqual(room["classification"] as? String, Classification.SocialSpace.rawValue)
            XCTAssertEqual(room["automated"] as? String, Automation.NotAutomated.rawValue)
            if let location = room["location"] as? [String: Any] {
                XCTAssertEqual(location["address"] as? String, "Gower Street, London, WC1E 6BT")
                if let coordinates = location["coordinates"] as? [String: Any] {
                    XCTAssertEqual(coordinates["latitude"] as? String, "51.524699")
                    XCTAssertEqual(coordinates["longitude"] as? String, "-0.13366")
                } else {
                    XCTAssert(false, "❌ Unable to cast Coordinate.")
                }
            } else {
                XCTAssert(false, "❌ Unable to cast Location.")
            }
        } else {
            XCTAssert(false, "❌ Unable to cast essential data.")
        }
    }

    func testBookingDictionaryParsing() {
        let response = Helper.codableFromFile("Bookings", type: BookingsResponse.self).toDictionary()
        if let bookings = response["bookings"] as? [Any], let booking = bookings[0] as? [String: Any] {
            XCTAssertEqual(response["OK"] as? String, "true")
            XCTAssertEqual(booking["slotID"] as? String, "998503")
            XCTAssertEqual(booking["endTime"] as? String, Time.iso8601Date("2016-09-02T18:00:00+00:00")!.description(with: Locale.current))
            XCTAssertEqual(booking["bookingDescription"] as? String, "split weeks to assist rooming 29.06")
            XCTAssertEqual(booking["roomName"] as? String, "Torrington (1-19) 433")
            XCTAssertEqual(booking["siteID"] as? String, "086")
            XCTAssertEqual(booking["contact"] as? String, "Ms Leah Markwick")
            XCTAssertEqual(booking["weekNumber"] as? String, "1")
            XCTAssertEqual(booking["roomID"] as? String, "433")
            XCTAssertEqual(booking["startTime"] as? String, Time.iso8601Date("2016-09-02T09:00:00+00:00")!.description(with: Locale.current))
            XCTAssertEqual(booking["phone"] as? String, "45699")
                XCTAssertEqual(response["nextPageExists"] as? String, "true")
                XCTAssertEqual(response["pageToken"] as? String, "6hb14hXjRV")
                XCTAssertEqual(response["count"] as? String, "1197")
        } else {
            XCTAssert(false, "❌ Unable to cast essential data.")
        }
    }

    func testEquipmentDictionaryParsing() {
        let response = Helper.codableFromFile("Equipment", type: EquipmentResponse.self).toDictionary()
        if let equipmentList = response["equipment"] as? [Any] {
            XCTAssertEqual(response["OK"] as? String, "true")
            if let equipment = equipmentList[0] as? [String: Any] {
                XCTAssertEqual(equipment["type"] as? String, Type.FixedFeature.rawValue)
                XCTAssertEqual(equipment["equipmentDescription"] as? String, "Managed PC")
                XCTAssertEqual(equipment["units"] as? String, "1")
            } else {
                XCTAssert(false, "❌ Unable to cast first equipment.")
            }
            if let equipment = equipmentList[1] as? [String: Any] {
                XCTAssertEqual(equipment["type"] as? String, Type.FixedEquipment.rawValue)
                XCTAssertEqual(equipment["equipmentDescription"] as? String, "Chairs with Tables")
                XCTAssertEqual(equipment["units"] as? String, "1")
            } else {
                XCTAssert(false, "❌ Unable to cast second equipment.")
            }
        } else {
            XCTAssert(false, "❌ Unable to cast essential data.")
        }
    }

    func testSearchDictionaryParsing() {
        let response = Helper.codableFromFile("People", type: PeopleResponse.self).toDictionary()
        if let people = response["people"] as? [Any], let person = people[0] as? [String: Any] {
            XCTAssertEqual(response["OK"] as? String, "true")
            XCTAssertEqual(person["name"] as? String, "Jane Doe")
            XCTAssertEqual(person["status"] as? String, Status.Student.rawValue)
            XCTAssertEqual(person["department"] as? String, "Dept of Med Phys & Biomedical Eng")
            XCTAssertEqual(person["email"] as? String, "jane.doe.17@ucl.ac.uk")
        } else {
            XCTAssert(false, "❌ Unable to cast essential data.")
        }
    }

    func testErrorParsing() {
        let session = URLTestSession(expectedURL: "https://uclapi.com/roombookings/rooms?capacity=&classification=&roomid=&roomname=&siteid=&sitename=&token=invalidToken", expectedHTTPMethod: "GET", jsonFile: "InvalidToken", statusCode: 400)
        let config = TokenConfiguration("invalidToken")
        _ = UCLKit(config).rooms(session) { response in
            switch response {
            case .success(let rooms):
                XCTAssert(false, "❌ Should retrieve an error, instead got –> (\(rooms))")
            case .failure(let error as NSError):
                XCTAssertEqual(UCLKit(config).parseError(error), "Token is invalid.")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }
}
