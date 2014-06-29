//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A singly-linked lazy list.
enum List<Element> {
	case Nil
	case Node(Element, List<Element>[])
	
	/// Nil case.
	init() {
		self = .Nil
	}
	
	/// List of one element.
	init(_ element: Element) {
		self = .Node(element, [ List.Nil ])
	}
	
	/// Prepending.
	init(_ element: Element, rest: List<Element>) {
		self = .Node(element, [ rest ])
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


/// Lists conform to Sequence.
extension List : Sequence {
	func generate() -> GeneratorOf<Element> {
		var list = self
		return GeneratorOf {
			switch list {
			case let .Node(x, next):
				list = next[0]
				return x
			case .Nil:
				return nil
			}
		}
	}
}


/// Lists conform to Printable.
extension List : Printable {
	var description: String {
		let joined = join(" ", map(self) { "\($0)" })
		return "(\(joined))"
	}
}


operator infix ++ { associativity right precedence 145 }

/// Concatenation of lists.
func ++ <Element> (left: List<Element>, right: List<Element>) -> List<Element> {
	let identity: List<Element> -> List<Element> = { $0 }
	func swap(into: List<Element> -> List<Element>, each: Element) -> List<Element> -> List<Element> {
		return { (x: List<Element>) -> List<Element> in into(List(each, rest: x)) }
	}
	let terminate = reduce(right, reduce(left, identity, swap), swap)
	return terminate(List.Nil)
}
