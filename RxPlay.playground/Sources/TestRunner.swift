import XCTest
import RxSwift

public class TestRunner {
    var deadBodies: DisposeBag = DisposeBag()
    
    public init() {
    }

    public func run(_ test: XCTestSuite) {
        Observable.of(test)
            .map { (test) in
                test.run()
                print("\n")
            }
            .subscribe()
            .disposed(by: deadBodies)
    }
}
