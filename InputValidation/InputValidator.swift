import AppKit
//import HoleFillingLib

struct InputValidator {

    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        return numberFormatter
    }()

    // TODO: it'd be automatically generatad currying ValidInput.init
    private let createInput = { (rgbBaseImageAbsolutePath: String) in
        { (rgbHoleMaskImageAbsolutePath: String) in
            { (z: Float) in
                { (epsilon: PositiveNonZeroFloat) in
                    { (pixelConnectivity: PixelConnectivity) in
                        { (outputImageAbsolutePath: String) in
                            ValidInput(
                                rgbBaseImageAbsolutePath: rgbBaseImageAbsolutePath,
                                rgbHoleMaskImageAbsolutePath: rgbHoleMaskImageAbsolutePath,
                                z: z,
                                epsilon: epsilon,
                                pixelConnectivity: pixelConnectivity,
                                outputImageAbsolutePath: outputImageAbsolutePath
                            )
                        }
                    }
                }
            }
        }
    }

    private let genericErrorMessage: ErrorMessage
    private let emptyAbsolutePathMessage: ErrorMessage
    private let invalidZMessage: ErrorMessage
    private let invalidEpsilonMessage: ErrorMessage
    private let invalidPixelConnectivityMessage: ErrorMessage

    public init(
        genericErrorMessage: ErrorMessage,
        emptyAbsolutePathMessage: ErrorMessage,
        invalidZMessage: ErrorMessage,
        invalidEpsilonMessage: ErrorMessage,
        invalidPixelConnectivityMessage: ErrorMessage) {

        self.genericErrorMessage = genericErrorMessage
        self.emptyAbsolutePathMessage = emptyAbsolutePathMessage
        self.invalidZMessage = invalidZMessage
        self.invalidEpsilonMessage = invalidEpsilonMessage
        self.invalidPixelConnectivityMessage = invalidPixelConnectivityMessage
    }
}

extension InputValidator: InputValidatorType {

    public func validate(arguments: [String]) -> Validation<ErrorMessage, ValidInput> {

        guard arguments.count == 6 else { return .invalid(genericErrorMessage) }

        return pure(createInput)
            .apply(validate(rgbBaseImageAbsolutePath: arguments[0]))
            .apply(validate(rgbHoleMaskImageAbsolutePath: arguments[1]))
            .apply(validate(z: arguments[2]))
            .apply(validate(epsilon: arguments[3]))
            .apply(validate(pixelConnectivity: arguments[4]))
            .apply(validate(outputImageAbsolutePath: arguments[5]))
    }

    private func validate(rgbBaseImageAbsolutePath: String) -> Validation<ErrorMessage, String> {
        return rgbBaseImageAbsolutePath.isEmpty
            ? .invalid(emptyAbsolutePathMessage)
            : .valid(rgbBaseImageAbsolutePath)
    }

    private func validate(rgbHoleMaskImageAbsolutePath: String) -> Validation<ErrorMessage, String> {
        return rgbHoleMaskImageAbsolutePath.isEmpty
            ? .invalid(emptyAbsolutePathMessage)
            : .valid(rgbHoleMaskImageAbsolutePath)
    }

    private func validate(z: String) -> Validation<ErrorMessage, Float> {
        guard let validZ = numberFormatter.number(from: z)?.floatValue else {
            return .invalid(invalidZMessage)
        }
        return .valid(validZ)
    }

    private func validate(epsilon: String) -> Validation<ErrorMessage, PositiveNonZeroFloat> {
        guard let epsilonFloat = numberFormatter.number(from: epsilon)?.floatValue,
            let validEpsilon = PositiveNonZeroFloat(floatValue: epsilonFloat) else {
            return .invalid(invalidEpsilonMessage)
        }
        return .valid(validEpsilon)
    }

    private func validate(pixelConnectivity: String) -> Validation<ErrorMessage, PixelConnectivity> {
        switch pixelConnectivity {
        case "4":
            return .valid(.fourConnected)
        case "8":
            return .valid(.eightConnected)
        default:
            return .invalid(invalidPixelConnectivityMessage)
        }
    }

    private func validate(outputImageAbsolutePath: String) -> Validation<ErrorMessage, String> {
        return outputImageAbsolutePath.isEmpty
            ? .invalid(emptyAbsolutePathMessage)
            : .valid(outputImageAbsolutePath)
    }
}
