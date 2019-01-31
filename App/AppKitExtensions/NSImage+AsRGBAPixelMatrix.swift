import CoreGraphics
import AppKit
//import HoleFillingLib

extension NSImage {

    public func asRGBAPixelMatrix() -> Matrix<RGBAPixel> {

        let bmp = cgImage(forProposedRect: nil, context: nil, hints: nil)!
            .dataProvider!
            .data!
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(bmp)
        var r, g, b, a: UInt8
        var result: [[RGBAPixel]] = []
        let rows = 0..<Int(self.size.height)
        let columns = 0..<Int(self.size.width)
        for _ in rows {
            var pixelsRow: [RGBAPixel] = []
            for _ in columns {
                r = data.pointee
                data = data.advanced(by: 1)
                g = data.pointee
                data = data.advanced(by: 1)
                b = data.pointee
                data = data.advanced(by: 1)
                a = data.pointee
                data = data.advanced(by: 1)
                let rgbaPixel = RGBAPixel(red: r, green: g, blue: b, alpha: a)
                pixelsRow.append(rgbaPixel)
            }
            result.append(pixelsRow)
        }
        return result.asRGBAPixelMatrix()!
    }
}
