//
//  TestTime.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 08/05/2017.
//  Copyright © 2017 Tiago Ferreira. All rights reserved.
//

import XCTest
import Foundation
@testable import UCLKit

let correctString = "2016-10-20T18:00:00Z"
let correctDateGMT = DateComponents(calendar: Calendar.current, timeZone: TimeZone(abbreviation: "GMT"), year: 2016, month: 10, day: 20, hour: 18, minute: 00, second: 00).date
let correctDatePST = DateComponents(calendar: Calendar.current, timeZone: TimeZone(abbreviation: "PST"), year: 2016, month: 10, day: 20, hour: 11, minute: 00, second: 00).date

class TimeTests: XCTestCase {

    func testGMTDateToString() {
        let converted = UCLKit.Time.parseDate(date: correctDateGMT)!
        XCTAssertEqual(converted, correctString)
    }

    func testPSTDateToString() {
        let converted = UCLKit.Time.parseDate(date: correctDatePST)!
        XCTAssertEqual(converted, correctString)
    }

    func testStringToDate() {
        let converted = UCLKit.Time.parseString(string: correctString)!
        XCTAssertEqual(converted, correctDateGMT)
    }

}
