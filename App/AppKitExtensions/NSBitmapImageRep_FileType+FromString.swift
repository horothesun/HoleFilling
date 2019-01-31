import AppKit

extension NSBitmapImageRep.FileType {

    public static func from(pathExtension: String) -> NSBitmapImageRep.FileType? {
        switch pathExtension {
        case "bmp":
            return .bmp
        case "gif":
            return .gif
        case "jpg", "jpeg":
            return .jpeg
        case "jp2":
            return .jpeg2000
        case "png":
            return .png
        case "tiff":
            return .tiff
        default:
            return nil
        }
    }
}
