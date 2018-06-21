import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(openwhisk_swift_sdkTests.allTests),
    ]
}
#endif