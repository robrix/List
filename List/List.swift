//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A singly-linked lazy list.
enum List<Element> {
	// MARK: Constructors

	/// Nil case.
	init() {
		self = .Nil
	}
	
	/// List of one element.
	init(_ element: Element) {
		self = .Cons(element, [ List.Nil ])
	}
	
	/// Prepending.
	init(_ element: Element, rest: List) {
		self = .Cons(element, [ rest ])
	}
	
	/// N-ary list from a generator.
	init<G: GeneratorType where G.Element == Element>(var generator: G) {
		if let next: Element = generator.next() {
			self = .Cons(next, [ List(generator: generator) ])
		} else {
			self = .Nil
		}
	}
	
	/// N-ary list from a sequence.
	init<S: SequenceType where S.Generator.Element == Element>(elements: S) {
		self = List(generator: elements.generate())
	}


	// MARK: Cases

	case Cons(Element, [List])
	case Nil
}


/// Lists conform to SequenceType.
extension List: SequenceType {
	func generate() -> GeneratorOf<Element> {
		var list = self
		return GeneratorOf {
			switch list {
			case let .Cons(x, next):
				list = next[0]
				return x
			case .Nil:
				return nil
			}
		}
	}
}


/// Lists conform to Printable.
extension List: Printable {
	var description: String {
		let joined = join(" ", map(self) { "\($0)" })
		return "(\(joined))"
	}
}


infix operator ++ { associativity right precedence 145 }

/// Concatenation of lists.
func ++ <Element> (left: List<Element>, right: List<Element>) -> List<Element> {
	func swap(into: List<Element> -> List<Element>, each: Element) -> List<Element> -> List<Element> {
		return { (x: List<Element>) -> List<Element> in into(List(each, rest: x)) }
	}
	let terminate = reduce(right, reduce(left, { $0 }, swap), swap)
	return terminate(nil)
}


/// Lists conform to NilLiteralConvertible.
extension List: NilLiteralConvertible {
	init(nilLiteral: ()) {
		self.init()
	}
}
