public typealias ErrorMessage = String

public protocol InputValidatorType {
    func validate(arguments: [String]) -> Validation<ErrorMessage, ValidInput>
}

enum ValidationErrorMessage {
    static let generic: ErrorMessage = """
        Expected arguments:
          - RGB base image absolute path
          - RGB hole mask image absolute path (hole represented by black pixels)
          - default weighting function 'z' parameter
          - default weighting function 'epsilon' parameter
          - pixel connectivity ("4" or "8")
          - output image absolute path

        🖼 Supported image formats: bmp, gif, jpeg, jpeg2000, png, tiff

        ℹ️ E.g.:
        $> ./HoleFilling \\
          "/Users/<username>/Documents/base.png" \\
          "/Users/<username>/Documents/holeMask.jpg" \\
          2 \\
          0.0001 \\
          4 \\
          "/Users/<username>/Downloads/holeFilled.tiff"
        """
    static let emptyAbsolutePath: ErrorMessage
        = "RGB base image absolute path can't be empty\n\n\(generic)"
    static let invalidZ: ErrorMessage
        = "Z must be a floating point number\n\n\(generic)"
    static let invalidEpsilon: ErrorMessage
        = "epsilon must be a floating point number > 0\n\n\(generic)"
    static let invalidPixelConnectivity: ErrorMessage
        = "Pixel connectivity must be '4' or '8'\n\n\(generic)"
}

public func buildInputValidatorType() -> InputValidatorType {
    return InputValidator(
        genericErrorMessage: ValidationErrorMessage.generic,
        emptyAbsolutePathMessage: ValidationErrorMessage.emptyAbsolutePath,
        invalidZMessage: ValidationErrorMessage.invalidZ,
        invalidEpsilonMessage: ValidationErrorMessage.invalidEpsilon,
        invalidPixelConnectivityMessage: ValidationErrorMessage.invalidPixelConnectivity
    )
}
