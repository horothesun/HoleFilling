public protocol HoleFillerType {
    func grayPixelMatrixWithFilledHole(
        baseGrayPixelMatrix: Matrix<GrayPixel>,
        holeMaskGrayPixelMatrix: Matrix<GrayPixel>,
        isHolePixel: @escaping (GrayPixel) -> Bool,
        weightingFunction: @escaping WeightingFunction,
        pixelConnectivity: PixelConnectivity) -> Matrix<GrayPixel>?
}

public func buildHoleFillerType() -> HoleFillerType {
    return HoleFiller()
}
