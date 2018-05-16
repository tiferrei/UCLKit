import XCTest

#if !(os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(UCLKitTests.allTests),
            testCase(RoomBookingTests.allTests),
            testCase(SearchTests.allTests),
            testCase(HelperToolsTests.allTests)
        ]
    }
#endif
