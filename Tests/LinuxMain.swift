import XCTest

import openwhisk_swift_sdkTests

var tests = [XCTestCaseEntry]()
tests += openwhisk_swift_sdkTests.allTests()
XCTMain(tests)