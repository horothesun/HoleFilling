extension RGBAPixel {

    public func asGrayPixel() -> GrayPixel {
        let whiteFloat = 0.299 * redFloat + 0.587 * greenFloat + 0.114 * blueFloat
        return GrayPixel(whiteFloat: whiteFloat, alphaFloat: alphaFloat)!
    }
}
