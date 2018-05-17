import XCTest

#if !(os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(UCLKitTests.allTests),
            testCase(RoomTests.allTests),
            testCase(BookingTests.allTests),
            testCase(EquipmentTests.allTests),
            testCase(FreeRoomsTests.allTests),
            testCase(SearchTests.allTests),
            testCase(HelperToolsTests.allTests)
        ]
    }
#endif
