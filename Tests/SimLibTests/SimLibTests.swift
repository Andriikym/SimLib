import XCTest
@testable import SimLib

final class SimLibTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SimLib().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
