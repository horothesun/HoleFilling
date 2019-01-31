import AppKit
//import HoleFillingLib
//import InputValidator

struct App {

    private let holeFiller: HoleFillerType
    private let validator: InputValidatorType

    init(holeFiller: HoleFillerType, validator: InputValidatorType) {
        self.holeFiller = holeFiller
        self.validator = validator
    }
}

extension App: AppType {

    func main(arguments commandLineArguments: [String]) {

        let arguments = commandLineArguments.dropFirst().asArray()

        switch validator.validate(arguments: arguments) {
        case .valid(let input):
            loadImagesAndSaveHoleFilledOne(with: input)
        case .invalid(let errorMessage):
            print("🛑 " + errorMessage)
        }
    }

    private func loadImagesAndSaveHoleFilledOne(with input: ValidInput) {

        guard let rgbBaseImage
            = rgbBaseImage(from: input.rgbBaseImageAbsolutePath) else { return }

        guard let rgbHoleMaskImage
            = rgbHoleMaskImage(from: input.rgbHoleMaskImageAbsolutePath) else { return }

        print("⏳ Base image grayscale conversion...")
        let baseGrayPixelMatrix = rgbBaseImage.asGrayPixelMatrix()
        print("✅ Base image converted to grayscale")

        print("⏳ Hole mask image grayscale conversion...")
        let holeMaskGrayPixelMatrix = rgbHoleMaskImage.asGrayPixelMatrix()
        print("✅ Hole mask image converted to grayscale")

        guard let holeFilledGrayMatrix = holeFilledGrayMatrix(
            baseGrayPixelMatrix: baseGrayPixelMatrix,
            holeMaskGrayPixelMatrix: holeMaskGrayPixelMatrix,
            z: input.z,
            epsilon: input.epsilon,
            pixelConnectivity: input.pixelConnectivity
            ) else { return }

        guard let holeFilledGrayImage
            = holeFilledGrayImage(from: holeFilledGrayMatrix) else { return }

        save(
            holeFilledGrayImage: holeFilledGrayImage,
            at: input.outputImageAbsolutePath
        )
    }

    private func rgbBaseImage(from rgbBaseImageAbsolutePath: String) -> NSImage? {
        print("⏳ Base image loading...")
        guard let rgbBaseImage = NSImage(contentsOfFile: rgbBaseImageAbsolutePath) else {
            print("🛑 Couldn't load \(rgbBaseImageAbsolutePath)")
            return nil
        }
        print("✅ Base image loaded")
        return rgbBaseImage
    }

    private func rgbHoleMaskImage(from rgbHoleMaskImageAbsolutePath: String) -> NSImage? {
        print("⏳ Hole mask image loading...")
        guard let rgbHoleMaskImage
            = NSImage(contentsOfFile: rgbHoleMaskImageAbsolutePath) else {
            print("🛑 Couldn't load \(rgbHoleMaskImageAbsolutePath)")
            return nil
        }
        print("✅ Hole mask image loaded")
        return rgbHoleMaskImage
    }

    private func holeFilledGrayMatrix(
        baseGrayPixelMatrix: Matrix<GrayPixel>,
        holeMaskGrayPixelMatrix: Matrix<GrayPixel>,
        z: Float,
        epsilon: PositiveNonZeroFloat,
        pixelConnectivity: PixelConnectivity) -> Matrix<GrayPixel>? {

        print("⏳ Hole filling...")
        guard let holeFilledGrayMatrix = holeFiller.grayPixelMatrixWithFilledHole(
            baseGrayPixelMatrix: baseGrayPixelMatrix,
            holeMaskGrayPixelMatrix: holeMaskGrayPixelMatrix,
            isHolePixel: { $0.isBlack },
            weightingFunction: defaultWeightingFunction(z: z, epsilon: epsilon),
            pixelConnectivity: pixelConnectivity
        ) else {
            print("🛑 Error while processing")
            return nil
        }
        print("✅ Hole filling completed")
        return holeFilledGrayMatrix
    }

    private func holeFilledGrayImage(
        from holeFilledGrayMatrix: Matrix<GrayPixel>) -> NSImage? {

        print("⏳ Hole filled gray image creation...")
        guard let holeFilledGrayImage = holeFilledGrayMatrix.asImage() else {
            print("🛑 Error converting processed data to image")
            return nil
        }
        print("✅ Hole filled gray image created")
        return holeFilledGrayImage
    }

    private func save(
        holeFilledGrayImage: NSImage,
        at outputImageAbsolutePath: String) {

        print("⏳ Hole filled gray image saving...")
        do {
            try holeFilledGrayImage.saveAs(fileAbsolutePath: outputImageAbsolutePath)
        } catch {
            print("🛑 Error saving image to disk")
        }
        print("✅ Hole filled gray image saved at: " + outputImageAbsolutePath)
    }
}
