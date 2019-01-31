public struct GrayPixel {

    public let white: UInt8
    public let alpha: UInt8

    public let whiteFloat: Float
    public let alphaFloat: Float

    public init(white: UInt8, alpha: UInt8) {
        self.white = white
        self.alpha = alpha

        self.whiteFloat = Float(white) / Float(UInt8.max)
        self.alphaFloat = Float(alpha) / Float(UInt8.max)
    }

    public init?(whiteFloat: Float, alphaFloat: Float) {
        guard whiteFloat >= 0 && whiteFloat <= 1
            && alphaFloat >= 0 && alphaFloat <= 1 else { return nil }

        self.whiteFloat = whiteFloat
        self.alphaFloat = alphaFloat

        self.white = UInt8(whiteFloat * Float(UInt8.max))
        self.alpha = UInt8(alphaFloat * Float(UInt8.max))
    }
}

extension GrayPixel: Hashable {

    public static func == (lhs: GrayPixel, rhs: GrayPixel) -> Bool {
        return lhs.white == rhs.white && lhs.alpha == rhs.alpha
    }

    public var hashValue: Int { return white.hashValue ^ alpha.hashValue }
}

extension GrayPixel {
    public var isBlack: Bool { return white == 0 }
}
