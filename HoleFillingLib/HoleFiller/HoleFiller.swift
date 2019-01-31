private struct Hole {
    let body: Set<Coordinate2D>
    let border: Set<Coordinate2D>
}

struct HoleFiller {
    private enum HoleFillerError: Error { case indexOutOfBounds }
}

extension HoleFiller: HoleFillerType {

    func grayPixelMatrixWithFilledHole(
        baseGrayPixelMatrix: Matrix<GrayPixel>,
        holeMaskGrayPixelMatrix: Matrix<GrayPixel>,
        isHolePixel: @escaping (GrayPixel) -> Bool,
        weightingFunction: @escaping WeightingFunction,
        pixelConnectivity: PixelConnectivity) -> Matrix<GrayPixel>? {

        guard baseGrayPixelMatrix.rowsCount == holeMaskGrayPixelMatrix.rowsCount,
            baseGrayPixelMatrix.columnsCount == holeMaskGrayPixelMatrix.columnsCount else {
            return nil
        }

        var baseGrayPixelMatrixCopy: Matrix<GrayPixel> = baseGrayPixelMatrix
        var holeMaskGrayPixelMatrixCopy: Matrix<GrayPixel> = holeMaskGrayPixelMatrix

        guard let hole =
            self.hole(
                grayPixelMatrix: &baseGrayPixelMatrixCopy,
                holeMaskGrayPixelMatrix: &holeMaskGrayPixelMatrixCopy,
                isHolePixel: isHolePixel,
                pixelConnectivity: pixelConnectivity
            ),
            var holeBodyWhiteFloatByCoordinate =
                self.holeBodyWhiteFloatByCoordinate(
                    hole: hole,
                    grayPixelMatrix: &baseGrayPixelMatrixCopy,
                    weightingFunction: weightingFunction
            )
            else { return nil }

        return grayPixelMatrixWithFilledHole(
            baseGrayPixelMatrix: &baseGrayPixelMatrixCopy,
            holeBodyWhiteFloatByCoordinate: &holeBodyWhiteFloatByCoordinate
        )
    }

    private func hole(
        grayPixelMatrix: inout Matrix<GrayPixel>,
        holeMaskGrayPixelMatrix: inout Matrix<GrayPixel>,
        isHolePixel: @escaping (GrayPixel) -> Bool,
        pixelConnectivity: PixelConnectivity) -> Hole? {

        var holeBody = Set<Coordinate2D>()
        var holeBorder = Set<Coordinate2D>()

        let rows = grayPixelMatrix.rowsCount
        let columns = grayPixelMatrix.columnsCount

        var addedToBorder = [[Bool]](
            repeating: [Bool](repeating: false, count: columns),
            count: rows
        )

        let isInBounds: (Coordinate2D) -> Bool = { u -> Bool in
            u.i >= 0 && u.i < rows && u.j >= 0 && u.j < columns
        }

        let coordinates = product(0..<rows, 0..<columns)
            .map(Coordinate2D.init(i:j:))

        for u in coordinates {

            guard let holeMaskPixel
                = holeMaskGrayPixelMatrix.element(at: u) else { return nil }

            if isHolePixel(holeMaskPixel) {

                holeBody.insert(u)

                let uInBoundsNeighbours =
                    neighbourCoordinates(accordingTo: pixelConnectivity)(u)
                        .filter(isInBounds)

                for n in uInBoundsNeighbours {
                    guard let pixel
                        = holeMaskGrayPixelMatrix.element(at: n) else { return nil }

                    if !isHolePixel(pixel) && !addedToBorder[n.i][n.j] {
                        holeBorder.insert(n)
                        addedToBorder[n.i][n.j] = true
                    }
                }
            }
        }

        return Hole(body: holeBody, border: holeBorder)
    }

    private func holeBodyWhiteFloatByCoordinate(
        hole: Hole,
        grayPixelMatrix: inout Matrix<GrayPixel>,
        weightingFunction: @escaping WeightingFunction) -> [Coordinate2D: Float]? {

        var holeBodyWhiteFloatByCoordinate = [Coordinate2D: Float]()

        for u in hole.body {
            var numerator: Float = 0
            var denominator: Float = 0

            for v in hole.border {
                guard let vGrayPixel = grayPixelMatrix.element(at: v) else { return nil }

                let weight_u_v = weightingFunction(u, v)

                numerator += weight_u_v * vGrayPixel.whiteFloat
                denominator += weight_u_v
            }

            let holeBodyWhiteFloat = numerator / denominator
            holeBodyWhiteFloatByCoordinate[u] = holeBodyWhiteFloat
        }

        return holeBodyWhiteFloatByCoordinate
    }

    private func grayPixelMatrixWithFilledHole(
        baseGrayPixelMatrix: inout Matrix<GrayPixel>,
        holeBodyWhiteFloatByCoordinate: inout [Coordinate2D: Float])
        -> Matrix<GrayPixel>? {

        var resultGrayPixels = baseGrayPixelMatrix.rawMatrix
        for (v, whiteFloat) in holeBodyWhiteFloatByCoordinate {
            guard let originalPixel = baseGrayPixelMatrix.element(at: v),
                let newGrayPixel = GrayPixel(
                    whiteFloat: whiteFloat,
                    alphaFloat: originalPixel.alphaFloat
                )  else { return nil }
            resultGrayPixels[v.i][v.j] = newGrayPixel
        }
        return Matrix<GrayPixel>(rawMatrix: resultGrayPixels)
    }
}
