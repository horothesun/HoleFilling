extension Validation {

    public func map<B>(_ a2b: (A) -> B) -> Validation<E, B> {
        switch self {
        case let .valid(a):
            return .valid(a2b(a))
        case let .invalid(e):
            return .invalid(e)
        }
    }
}
