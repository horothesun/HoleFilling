extension Matrix where T == RGBAPixel {

    public func asGrayPixelMatrix() -> Matrix<GrayPixel> {
        return map { $0.asGrayPixel() }!
    }
}
