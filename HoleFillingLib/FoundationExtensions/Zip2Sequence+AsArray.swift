extension Zip2Sequence {

    public func asArray() -> [(Sequence1.Element, Sequence2.Element)] {
        return Array(self)
    }
}
