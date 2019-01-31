import XCTest
@testable import InputValidation

final class InputValidatorTests: XCTestCase {

    private let validator = InputValidator(
        genericErrorMessage: "",
        emptyAbsolutePathMessage: "",
        invalidZMessage: "",
        invalidEpsilonMessage: "",
        invalidPixelConnectivityMessage: ""
    )

    private let genericInvalid: Validation<ErrorMessage, ValidInput>
        = .invalid("ignored error message")

    func testValidateArguments_with4Arguments_mustReturnInvalid() {

        // given
        let arguments = [
            "/Users/<username>/Desktop/base.jpg",
            "/Users/<username>/Desktop/holeMask.jpg",
            "2",
            "0.001"
        ]

        // when
        let result = validator.validate(arguments: arguments)

        // then
        XCTAssertEqual(result, genericInvalid)
    }

    func testValidateArguments_with6ArgumentsAndEmptyBasePath_mustReturnInvalid() {

        // given
        let arguments = [
            "",
            "/Users/<username>/Desktop/holeMask.jpg",
            "2",
            "0.001",
            "8",
            "/Users/<username>/Desktop/out.tiff"
        ]

        // when
        let result = validator.validate(arguments: arguments)

        // then
        XCTAssertEqual(result, genericInvalid)
    }

    func testValidateArguments_with6ArgumentsAndEmptyHoleMaskPath_mustReturnInvalid() {

        // given
        let arguments = [
            "/Users/<username>/Desktop/base.jpg",
            "",
            "2",
            "0.001",
            "8",
            "/Users/<username>/Desktop/out.tiff"
        ]

        // when
        let result = validator.validate(arguments: arguments)

        // then
        XCTAssertEqual(result, genericInvalid)
    }

    func testValidateArguments_with6ArgumentsAndInvalidZ_mustReturnInvalid() {

        // given
        let arguments = [
            "/Users/<username>/Desktop/base.jpg",
            "/Users/<username>/Desktop/holeMask.jpg",
            "😁",
            "0.001",
            "8",
            "/Users/<username>/Desktop/out.tiff"
        ]

        // when
        let result = validator.validate(arguments: arguments)

        // then
        XCTAssertEqual(result, genericInvalid)
    }

    func testValidateArguments_with6ArgumentsAndNegativeEpsilon_mustReturnInvalid() {

        // given
        let arguments = [
            "/Users/<username>/Desktop/base.jpg",
            "/Users/<username>/Desktop/holeMask.jpg",
            "2",
            "-0.8",
            "8",
            "/Users/<username>/Desktop/out.tiff"
        ]

        // when
        let result = validator.validate(arguments: arguments)

        // then
        XCTAssertEqual(result, genericInvalid)
    }

    func testValidateArguments_with6ArgumentsAndInvalidPixelConnectivity_mustReturnInvalid() {

        // given
        let arguments = [
            "/Users/<username>/Desktop/base.jpg",
            "/Users/<username>/Desktop/holeMask.jpg",
            "2",
            "0.001",
            "10",
            "/Users/<username>/Desktop/out.tiff"
        ]

        // when
        let result = validator.validate(arguments: arguments)

        // then
        XCTAssertEqual(result, genericInvalid)
    }

    func testValidateArguments_with6ArgumentsAndEmptyOutputPath_mustReturnInvalid() {

        // given
        let arguments = [
            "/Users/<username>/Desktop/base.jpg",
            "/Users/<username>/Desktop/holeMask.jpg",
            "2",
            "0.001",
            "8",
            ""
        ]

        // when
        let result = validator.validate(arguments: arguments)

        // then
        XCTAssertEqual(result, genericInvalid)
    }

    func testValidateArguments_with6ValidArguments_mustReturnValidInput() {

        // given
        let rgbBaseImageAbsolutePath = "/Users/<username>/Desktop/base.jpg"
        let rgbHoleMaskImageAbsolutePath = "/Users/<username>/Desktop/holeMask.jpg"
        let z = "2"
        let epsilon = "0.001"
        let pixelConnectivity = "8"
        let outputImageAbsolutePath = "/Users/<username>/Desktop/out.tiff"
        let arguments = [
            rgbBaseImageAbsolutePath,
            rgbHoleMaskImageAbsolutePath,
            z,
            epsilon,
            pixelConnectivity,
            outputImageAbsolutePath
        ]

        // when
        let result = validator.validate(arguments: arguments)

        // then
        let expected = ValidInput(
            rgbBaseImageAbsolutePath: rgbBaseImageAbsolutePath,
            rgbHoleMaskImageAbsolutePath: rgbHoleMaskImageAbsolutePath,
            z: 2.0,
            epsilon: PositiveNonZeroFloat(floatValue: 0.001)!,
            pixelConnectivity: .eightConnected,
            outputImageAbsolutePath: outputImageAbsolutePath
        )
        XCTAssertEqual(result, .valid(expected))
    }
}
