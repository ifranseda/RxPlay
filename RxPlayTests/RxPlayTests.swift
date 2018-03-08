//
//  RxPlayTests.swift
//  RxPlayTests
//
//  Created by Isnan Franseda on 3/9/18.
//  Copyright © 2018 Isnan Franseda. All rights reserved.
//

import XCTest
import RxExpect
import RxSwift
import RxTest

@testable import RxPlay

class RxPlayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
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
        test.assert(result) { events in
            XCTAssertEqual(events, [
                Recorded.next(100, 2),
                Recorded.next(200, 4),
                Recorded.next(300, 6),
                Recorded.completed(400)
                ])
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
