//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A singly-linked lazy list.
enum List<Element>: NilLiteralConvertible, Printable {
	// MARK: Constructors

	/// Nil case.
	init() {
		self = Nil
	}
	
	/// List of one element.
	init(_ element: Element) {
		self = Cons(element, Box(nil))
	}
	
	/// Prepending.
	init(_ element: Element, rest: List) {
		self = Cons(element, Box(rest))
	}
	
	/// N-ary list from a generator.
	init<G: GeneratorType where G.Element == Element>(var generator: G) {
		self = generator.next().map { Cons($0, Box(List(generator: generator))) } ?? nil
	}
	
	/// N-ary list from a sequence.
	init<S: SequenceType where S.Generator.Element == Element>(elements: S) {
		self = List(generator: elements.generate())
	}


	// MARK: NilLiteralConvertible

	init(nilLiteral: ()) {
		self.init()
	}


	// MARK: Printable

	var description: String {
		let joined = join(" ", map(self) { "\($0)" })
		return "(\(joined))"
	}


	// MARK: Cases

	case Cons(Element, Box<List>)
	case Nil
}


/// Lists conform to SequenceType.
extension List: SequenceType {
	func generate() -> GeneratorOf<Element> {
		var list = self
		return GeneratorOf {
			switch list {
			case let Cons(x, next):
				list = next.value
				return x
			case .Nil:
				return nil
			}
		}
	}
}


infix operator ++ { associativity right precedence 145 }

/// Concatenation of lists.
func ++ <Element> (left: List<Element>, right: List<Element>) -> List<Element> {
	func swap(into: List<Element> -> List<Element>, each: Element) -> List<Element> -> List<Element> {
		return { into(List(each, rest: $0)) }
	}
	let terminate = reduce(right, reduce(left, { $0 }, swap), swap)
	return terminate(nil)
}


// MARK: - Imports

import Box
