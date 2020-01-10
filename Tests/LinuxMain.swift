import XCTest

import SwiftCLTests
import MyKernelTests

var tests = [XCTestCaseEntry]()
tests += SwiftCLTests.allTests()
tests += MyKernelTests.allTests()
XCTMain(tests)
