//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A singly-linked lazy list.
public enum List<Element>: NilLiteralConvertible, CustomStringConvertible, SequenceType {
	// MARK: Constructors

	/// Constructs an empty list.
	public init() {
		self = Nil
	}
	
	/// List of one element.
	public init(_ element: Element) {
		self = Cons(element, nil)
	}
	
	/// Prepending.
	public init(_ element: Element, _ rest: List) {
		self = Cons(element, rest)
	}
	
	/// N-ary list from a generator.
	public init<G: GeneratorType where G.Element == Element>(var generator: G) {
		self = generator.next().map { List($0, List(generator: generator)) } ?? nil
	}
	
	/// N-ary list from a sequence.
	public init<S: SequenceType where S.Generator.Element == Element>(elements: S) {
		self = List(generator: elements.generate())
	}


	// MARK: Properties

	/// Returns the head element, or `nil` if the receiver is empty.
	public var head: Element? {
		return analysis { head, _ in head }
	}

	/// Returns the tail, i.e. the (possibly empty) list of elements following the head element.
	public var tail: List {
		return analysis { _, tail in tail } ?? nil
	}

	/// `true` if the receiver is empty, `false` otherwise.
	public var isEmpty: Bool {
		return analysis { _, _ in false } ?? true
	}


	/// Case analysis.
	///
	/// If the receiver is empty, returns `nil`. Otherwise returns the result of applying `f` to the receiver’s head & tail.
	public func analysis<T>(f: (Element, List) -> T) -> T? {
		switch self {
		case let Cons(head, tail):
			return f(head, tail)

		case Nil:
			return nil
		}
	}


	// MARK: Higher-order functions

	public func map<T>(transform: Element -> T) -> List<T> {
		return analysis { List<T>(transform($0), $1.map(transform)) } ?? nil
	}

	public func filter(includeElement: Element -> Bool) -> List {
		return analysis {
			let rest = $1.filter(includeElement)
			return includeElement($0) ? List($0, rest) : rest
		} ?? nil
	}

	public func reduce<Result>(initial: Result, _ combine: (Result, Element) -> Result) -> Result {
		return analysis { $1.reduce(combine(initial, $0), combine) } ?? initial
	}


	// MARK: NilLiteralConvertible

	public init(nilLiteral: ()) {
		self.init()
	}


	// MARK: Printable

	public var description: String {
		let joined = " ".join(lazy(self).map{ String($0) })
		return "(\(joined))"
	}


	// MARK: SequenceType

	public func generate() -> AnyGenerator<Element> {
		var list = self
		return anyGenerator {
			list.analysis {
				list = $1
				return $0
			} ?? nil
		}
	}


	// MARK: Cases

	indirect case Cons(Element, List)
	case Nil
}


infix operator ++ { associativity right precedence 145 }

/// Concatenation of lists.
public func ++ <Element> (left: List<Element>, right: List<Element>) -> List<Element> {
	func swap(into: List<Element> -> List<Element>, each: Element) -> List<Element> -> List<Element> {
		return { into(List(each, $0)) }
	}
	return right.reduce(left.reduce({ $0 }, swap), swap)(nil)
}
