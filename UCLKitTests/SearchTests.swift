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

    // MARK: Request Tests

    func testSearchPeople() {
        let session = URLTestSession(expectedURL: "https://uclapi.com/search/people?access_token=12345&query=Jane", expectedHTTPMethod: "GET", jsonFile: "People", statusCode: 200)
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
        let session = URLTestSession(expectedURL: "https://uclapi.com/search/people?access_token=12345&query=", expectedHTTPMethod: "GET", jsonFile: "People", statusCode: 400)
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
        let response = Helper.codableFromFile("People", type: PeopleResponse.self)
        XCTAssertEqual(response.OK, true)
        XCTAssertEqual(response.people![0].name, "Jane Doe")
        XCTAssertEqual(response.people![0].status, Status.Student)
        XCTAssertEqual(response.people![0].department, "Dept of Med Phys & Biomedical Eng")
        XCTAssertEqual(response.people![0].email, "jane.doe.17@ucl.ac.uk")
    }
}
