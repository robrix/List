//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A singly-linked lazy list.
public enum List<Element>: NilLiteralConvertible, Printable, SequenceType {
	// MARK: Constructors

	/// Constructs an empty list.
	public init() {
		self = Nil
	}
	
	/// List of one element.
	public init(_ element: Element) {
		self = Cons(element, Box(nil))
	}
	
	/// Prepending.
	public init(_ element: Element, rest: List) {
		self = Cons(element, Box(rest))
	}
	
	/// N-ary list from a generator.
	public init<G: GeneratorType where G.Element == Element>(var generator: G) {
		self = generator.next().map { Cons($0, Box(List(generator: generator))) } ?? nil
	}
	
	/// N-ary list from a sequence.
	public init<S: SequenceType where S.Generator.Element == Element>(elements: S) {
		self = List(generator: elements.generate())
	}


	// MARK: NilLiteralConvertible

	public init(nilLiteral: ()) {
		self.init()
	}


	// MARK: Printable

	public var description: String {
		let joined = join(" ", map(self) { "\($0)" })
		return "(\(joined))"
	}


	// MARK: SequenceType

	public func generate() -> GeneratorOf<Element> {
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


	// MARK: Cases

	case Cons(Element, Box<List>)
	case Nil
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
