import XCTest

public class MyTests : XCTestCase {
    func testShouldFail() {
        XCTFail("failed!")
    }
    
    func testShouldPass() {
        XCTAssertEqual(2 + 2, 4)
    }
}
