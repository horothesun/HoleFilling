public struct RGBAPixel {

    public let red: UInt8
    public let green: UInt8
    public let blue: UInt8
    public let alpha: UInt8

    public let redFloat: Float
    public let greenFloat: Float
    public let blueFloat: Float
    public let alphaFloat: Float

    public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha

        self.redFloat   = Float(red)   / Float(UInt8.max)
        self.greenFloat = Float(green) / Float(UInt8.max)
        self.blueFloat  = Float(blue)  / Float(UInt8.max)
        self.alphaFloat = Float(alpha) / Float(UInt8.max)
    }
}

extension RGBAPixel: Hashable {

    public static func == (lhs: RGBAPixel, rhs: RGBAPixel) -> Bool {
        return lhs.red == rhs.red
            && lhs.green == rhs.green
            && lhs.blue == rhs.blue
            && lhs.alpha == rhs.alpha
    }

    public var hashValue: Int {
        return red.hashValue ^ green.hashValue ^ blue.hashValue ^ alpha.hashValue
    }
}
