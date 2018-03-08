import XCTest
import RxSwift
import RxTest
import RxBlocking

public class RxTestSample: XCTestCase {

    func testMap_Range() {
        // Initializes test scheduler.
        // Test scheduler implements virtual time that is
        // detached from local machine clock.
        // This enables running the simulation as fast as possible
        // and proving that all events have been handled.
        let scheduler = TestScheduler(initialClock: 0)
        
        // Creates a mock hot observable sequence.
        // The sequence will emit events at designated
        // times, no matter if there are observers subscribed or not.
        // (that's what hot means).
        // This observable sequence will also record all subscriptions
        // made during its lifetime (`subscriptions` property).
        let xs = scheduler.createHotObservable([
            Recorded.next(150, 1),
            Recorded.next(210, 0),
            Recorded.next(220, 1),
            Recorded.next(230, 2),
            Recorded.next(240, 4),
            Recorded.completed(300) // virtual time when completed is sent
            ])
        
        // `start` method will by default:
        // * Run the simulation and record all events
        //   using observer referenced by `res`.
        // * Subscribe at virtual time 200
        // * Dispose subscription at virtual time 1000
        let res = scheduler.start { xs.map { $0 * 2 } }
        
        let correctMessages = [
            Recorded.next(210, 0 * 2),
            Recorded.next(220, 1 * 2),
            Recorded.next(230, 2 * 2),
            Recorded.next(240, 4 * 2),
            Recorded.completed(300)
        ]
        
        let correctSubscriptions = [
            Subscription(200, 300)
        ]
        
        XCTAssertEqual(res.events, correctMessages)
        XCTAssertEqual(xs.subscriptions, correctSubscriptions)
    }
}
