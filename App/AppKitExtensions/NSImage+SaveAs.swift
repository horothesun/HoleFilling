import AppKit

extension NSImage {

    private enum SaveAsError: Error { case invalidParameters, invalidTiffConversion }

    // TODO: wrap asynchronously (e.g. returning Promise<Bool> or Observable<Bool>)
    public func saveAs(
        fileName: String,
        fileType: NSBitmapImageRep.FileType,
        at directory: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)) throws {

        guard let tiffRepresentation = tiffRepresentation,
            directory.isDirectory,
            !fileName.isEmpty else { throw SaveAsError.invalidParameters }

        let fileUrl = directory
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileType.pathExtension)

        try NSBitmapImageRep(data: tiffRepresentation)?
            .representation(using: fileType, properties: [:])?
            .write(to: fileUrl)
    }

    // TODO: wrap asynchronously (e.g. returning Promise<Bool> or Observable<Bool>)
    public func saveAs(fileAbsolutePath: String) throws {

        let file = URL(fileURLWithPath: fileAbsolutePath)
        let fileNameAndExtension = file.lastPathComponent.split(separator: ".")

        guard fileNameAndExtension.count == 2,
            let fileNameSubSequence = fileNameAndExtension.first,
            !fileNameSubSequence.isEmpty,
            let fileType = NSBitmapImageRep.FileType
                .from(pathExtension: file.pathExtension) else {
            throw SaveAsError.invalidParameters
        }

        let fileName = String(fileNameSubSequence)
        let dictionary = file.deletingLastPathComponent()

        try saveAs(fileName: fileName, fileType: fileType, at: dictionary)
    }
}
