extension Validation {

    public func apply<C, D>(_ c: Validation<E, C>) -> Validation<E, D> where A == (C) -> D  {
        switch self {
        case let .valid(f): return c.map(f)
        case let .invalid(e): return .invalid(e)
        }
    }
}

func pure<E, A>(_ a: A) -> Validation<E, A> { return .valid(a) }
