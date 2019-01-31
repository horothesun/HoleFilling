import AppKit
//import HoleFillingLib

extension NSImage {

    public func asGrayPixelMatrix() -> Matrix<GrayPixel> {
        return asRGBAPixelMatrix().asGrayPixelMatrix()
    }
}
