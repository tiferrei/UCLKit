//
//  ErrorHandlingTests.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 13/03/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import XCTest
import Foundation
import RequestKit
@testable import UCLKit

class ErrorHandlingTests: XCTestCase {

    // MARK: Parsing Tests

    func testFailToGetRooms() {
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
