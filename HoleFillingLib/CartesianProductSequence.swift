public struct CartesianProductIterator<X, Y>: IteratorProtocol
    where X: IteratorProtocol, Y: Collection {

    private var xIt: X
    private let yCol: Y

    private var x: X.Element?
    private var yIt: Y.Iterator

    public init(xs: X, ys: Y) {
        xIt = xs
        yCol = ys

        x = xIt.next()
        yIt = yCol.makeIterator()
    }

    public typealias Element = (X.Element, Y.Element)

    public mutating func next() -> Element? {

        guard !yCol.isEmpty,
            let someX = x else { return nil }

        guard let someY = yIt.next() else {
            yIt = yCol.makeIterator()
            x = xIt.next()
            return next()
        }

        return (someX, someY)
    }
}

public struct CartesianProductSequence<X, Y>: Sequence where X: Sequence, Y: Collection {

    public typealias Iterator = CartesianProductIterator<X.Iterator, Y>

    private let xs: X
    private let ys: Y

    public init(xs: X, ys: Y) {
        self.xs = xs
        self.ys = ys
    }

    public func makeIterator() -> Iterator {
        return Iterator(xs: xs.makeIterator(), ys: ys)
    }
}

public func product<X, Y>(_ xs: X, _ ys: Y)
    -> CartesianProductSequence<X, Y> where X: Sequence, Y: Collection {

    return CartesianProductSequence(xs: xs, ys: ys)
}
