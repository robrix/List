//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A singly-linked lazy list.
enum List<Element> {
	case Nil
	case Node(Element, List<Element>[]?)
	
	/// Nil case.
	init() {
		self = .Nil
	}
	
	/// List of one element.
	init(_ element: Element) {
		self = .Node(element, nil)
	}
	
	/// Prepending.
	init(_ element: Element, rest: List<Element>) {
		self = .Node(element, [rest])
	}
	
	/// N-ary list from a generator.
	init<G : Generator where G.Element == Element>(var generator: G) {
		if let next: Element = generator.next() {
			self = .Node(next, [ List(generator: generator) ])
		} else {
			self = .Nil
		}
	}
	
	/// N-ary list from a sequence.
	init<S : Sequence where S.GeneratorType.Element == Element>(elements: S) {
		self = List(generator: elements.generate())
	}
}
