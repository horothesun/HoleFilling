import AppKit
//import HoleFillingLib

extension GrayPixel {

    var color: NSColor {
        return NSColor(
            white: CGFloat(whiteFloat),
            alpha: CGFloat(alphaFloat)
        )
    }

    var description: String { return "WA(\(whiteFloat), \(alphaFloat))" }

    var blackDescription: String { return isBlack ? "⚫️" : "⚪️" }
}
