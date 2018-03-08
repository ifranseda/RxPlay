import XCTest
import RxCocoa
import RxExpect
import RxSwift
import RxTest

public class RxExpectSample: XCTestCase {
    
    func testMultiply() {
        let test = RxExpect()
        let value = PublishSubject<Int>()
        let result = value.map { $0 * 2 }
        
        // provide inputs
        test.input(value, [
            Recorded.next(100, 1),
            Recorded.next(200, 2),
            Recorded.next(300, 3),
            Recorded.completed(400)
            ])
        
        // test output
        test.assert(result) { values in
            XCTAssertEqual(values, [
                Recorded.next(100, 2),
                Recorded.next(200, 4),
                Recorded.next(300, 6),
                Recorded.completed(400)
                ])
        }
    }
}
