//  Copyright (c) 2014 Rob Rix. All rights reserved.

final class ListTests: XCTestCase {
	func testDescription() {
		XCTAssert(List(elements: [1, 2, 3, 4]).description == "(1 2 3 4)")
	}
	
	func testConcatenation() {
		let a = List(elements: [1, 2, 3])
		let b = List(elements: [4, 5, 6])
		XCTAssert((a ++ b).description == "(1 2 3 4 5 6)")
	}
	
	func testNilConversion() {
		let x: List<Int> = nil
		XCTAssert(x.description == "()")
	}


	func testMap() {
		XCTAssertEqual(Array(List<Int>(0, List(1, List(2))).map(String.init)), ["0", "1", "2"])
	}

	func testFilter() {
		XCTAssertEqual(Array(List(elements: [0, 1, 2, 3]).filter { $0 % 2 == 0 }), [0, 2])
	}

	func testReduce() {
		XCTAssertEqual(List(elements: [1, 2, 3, 4, 5]).reduce(0, +), 15)
	}
}


@testable import List
import XCTest
