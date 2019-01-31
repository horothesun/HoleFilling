extension Array where Element == [RGBAPixel] {

    public func asRGBAPixelMatrix() -> Matrix<RGBAPixel>? {
        return Matrix<RGBAPixel>(rawMatrix: self)
    }
}
