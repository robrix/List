//  Copyright (c) 2014 Rob Rix. All rights reserved.

import XCTest
import List

class ListTests: XCTestCase {
	func testDescription() {
		XCTAssert(List(elements: [1, 2, 3, 4]).description == "(1 2 3 4)")
	}
}
