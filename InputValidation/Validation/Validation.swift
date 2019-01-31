public enum Validation<E, A> {
    case valid(A)
    case invalid(E)
}
