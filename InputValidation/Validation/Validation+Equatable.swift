extension Validation: Equatable where A: Equatable {

    public static func == (lhs: Validation<E, A>, rhs: Validation<E, A>) -> Bool {
        switch (lhs, rhs) {
        case let (.valid(lhsA), .valid(rhsA)):
            return lhsA == rhsA
        case (.invalid, .invalid):
            return true
        default:
            return false
        }
    }
}
