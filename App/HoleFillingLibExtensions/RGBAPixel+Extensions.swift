import AppKit
//import HoleFillingLib

extension RGBAPixel {

    var color: NSColor {
        return NSColor(
            red: CGFloat(redFloat),
            green: CGFloat(greenFloat),
            blue: CGFloat(blueFloat),
            alpha: CGFloat(alphaFloat)
        )
    }

    var description: String {
        return "RGBA(\(redFloat), \(greenFloat), \(blueFloat), \(alphaFloat))"
    }
}
