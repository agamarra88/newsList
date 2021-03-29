import XCTest

import DataAccessTests

var tests = [XCTestCaseEntry]()
tests += DataAccessTests.allTests()
XCTMain(tests)
