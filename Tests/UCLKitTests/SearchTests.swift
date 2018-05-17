//
//  SearchTests.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 27/11/2017.
//  Copyright © 2017 Tiago Ferreira. All rights reserved.
//

import XCTest
import Foundation
@testable import UCLKit

class SearchTests: XCTestCase {
    static var allTests = [
        ("testSearchPeople", testSearchPeople),
        ("testFailToSearchPeople", testFailToSearchPeople),
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

    func testSearchPeople() {
        let sessionURL = "https://uclapi.com/search/people?query=Jane&token=12345"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .People, statusCode: 200)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).people(session, query: "Jane") { response in
            switch response {
            case .success(let response):
                XCTAssertEqual(response.OK, true)
            case .failure(let error):
                XCTAssert(false, "❌ Should not retrieve an error –> (\(error))")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToSearchPeople() {
        let sessionURL = "https://uclapi.com/search/people?query=&token=12345"
        let session = URLTestSession(expectedURL: sessionURL, expectedHTTPMethod: "GET", resource: .People, statusCode: 400)
        let config = TokenConfiguration("12345")
        _ = UCLKit(config).people(session, query: "") { response in
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

    func testRoomsParsing() {
        let response = Helper.codableFromResource(.People, type: PeopleResponse.self)
        XCTAssertEqual(response.OK, true)
        XCTAssertEqual(response.people![0].name, "Jane Doe")
        XCTAssertEqual(response.people![0].status, Status.Student)
        XCTAssertEqual(response.people![0].department, "Dept of Med Phys & Biomedical Eng")
        XCTAssertEqual(response.people![0].email, "jane.doe.17@ucl.ac.uk")
    }
}
