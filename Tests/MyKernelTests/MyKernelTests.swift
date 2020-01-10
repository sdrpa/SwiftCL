import XCTest
@testable import MyKernel

final class MyKernelTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftCL().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
