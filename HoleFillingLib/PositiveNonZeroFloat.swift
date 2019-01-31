public struct PositiveNonZeroFloat {

    public let floatValue: Float

    public init?(floatValue: Float) {
        guard floatValue > 0 else { return nil }
        self.floatValue = floatValue
    }
}
