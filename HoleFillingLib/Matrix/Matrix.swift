public struct Matrix<T> {

    public let rawMatrix: [[T]]
    public let rowsCount: Int
    public let columnsCount: Int

    init?(rawMatrix: [[T]]) {
        let isColumnsCountSameForAllRows = rawMatrix
            .map { $0.count }
            .areAllElementsSame
        guard isColumnsCountSameForAllRows else { return nil }

        self.rawMatrix = rawMatrix
        self.rowsCount = rawMatrix.count
        self.columnsCount = rawMatrix.count == 0 ? 0 : rawMatrix[0].count
    }

    public func element(at coordinate: Coordinate2D) -> T? {
        guard coordinate.i >= 0
            && coordinate.i < rowsCount
            && coordinate.j >= 0
            && coordinate.j < columnsCount else { return nil }

        return rawMatrix[coordinate.i][coordinate.j]
    }
}
