import Foundation
import AppKit
import CoreGraphics
//import HoleFillingLib

private struct PixelData {
    var a: UInt8 = 0
    var r: UInt8 = 0
    var g: UInt8 = 0
    var b: UInt8 = 0

    init(grayPixel: GrayPixel) {
        a = grayPixel.alpha
        r = grayPixel.white
        g = grayPixel.white
        b = grayPixel.white
    }
}

extension Matrix where T == GrayPixel {

    func asImage() -> NSImage? {

        let pixelData: [PixelData] = rawMatrix
            .reduce([PixelData]()) { partialResult, grayPixelsRow -> [PixelData] in
                partialResult + grayPixelsRow.map(PixelData.init(grayPixel:))
            }
        return imageFromBitmap(
            pixels: pixelData,
            rows: rowsCount,
            columns: columnsCount
        )
    }

    private func imageFromBitmap(
        pixels: [PixelData],
        rows: Int,
        columns: Int) -> NSImage? {

        guard columns > 0, rows > 0 else { return nil }

        let pixelDataSize = MemoryLayout<PixelData>.size

        guard pixelDataSize == 4,
            pixels.count == rows * columns else { return nil }

        let data: Data = pixels.withUnsafeBufferPointer(Data.init(buffer:))
        let cfData = NSData(data: data) as CFData

        guard let provider = CGDataProvider(data: cfData),
            let cgImage = CGImage(
                width: columns,
                height: rows,
                bitsPerComponent: 8,
                bitsPerPixel: 32,
                bytesPerRow: columns * pixelDataSize,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGBitmapInfo(
                    rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue
                ),
                provider: provider,
                decode: nil,
                shouldInterpolate: true,
                intent: .defaultIntent
            ) else { return nil }

        let size = NSSize(width: columns, height: rows)
        return NSImage(cgImage: cgImage, size: size)
    }
}
