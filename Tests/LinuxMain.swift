import XCTest
@testable import UCLKitTests

XCTMain([
    testCase(UCLKitTests.allTests),
    testCase(RoomTests.allTests),
    testCase(BookingTests.allTests),
    testCase(EquipmentTests.allTests),
    testCase(FreeRoomsTests.allTests),
    testCase(SearchTests.allTests),
    testCase(HelperToolsTests.allTests)
])
