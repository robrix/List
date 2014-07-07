//  Copyright (c) 2014 Rob Rix. All rights reserved.

import XCTest
import List

class ListTests: XCTestCase {
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
}
