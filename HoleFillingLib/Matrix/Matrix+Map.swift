extension Matrix {

    public func map<R>(_ f: (T) throws -> R) -> Matrix<R>? {

        let newOptionalRawMatrix = try? rawMatrix.map { row -> [R] in
            do { return try row.map(f) } catch { throw error }
        }
        guard let newRawMatrix = newOptionalRawMatrix else { return nil }

        return Matrix<R>(rawMatrix: newRawMatrix)
    }
}
