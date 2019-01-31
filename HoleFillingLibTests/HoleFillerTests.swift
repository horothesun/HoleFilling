import XCTest
@testable import HoleFillingLib

final class HoleFillerTests: XCTestCase {

    private let holeFiller = HoleFiller()

    func testGrayPixelMatrixWithFilledHole_withBaseAndHoleMaskMatrixesOfDifferentSizes_mustReturnNil() {

        // given
        let baseWhiteFloats: [[Float]] = [
            [1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 0.1, 1.0],
            [1.0, 0.5, 0.2, 1.0],
            [1.0, 0.8, 0.0, 1.0],
            [1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0]
        ]
        let baseGrayPixelMatrix = Matrix<GrayPixel>(
            rawMatrix: baseWhiteFloats.map {
                $0.lazy
                    .map { ($0, 1.0) }
                    .map(GrayPixel.init(whiteFloat:alphaFloat:))
                    .map { $0! }
            }
        )!
        let holeMaskWhiteFloats: [[Float]] = [
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 0.0, 0.0, 1.0, 1.0],
            [1.0, 0.0, 0.0, 0.0, 1.0],
            [1.0, 1.0, 0.0, 0.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0]
        ]
        let holeMaskGrayPixelMatrix = Matrix<GrayPixel>(
            rawMatrix: holeMaskWhiteFloats.map {
                $0.lazy
                    .map { ($0, 1.0) }
                    .map(GrayPixel.init(whiteFloat:alphaFloat:))
                    .map { $0! }
            }
        )!
        let isHolePixel: (GrayPixel) -> Bool = { $0.isBlack }
        let weightingFunction: WeightingFunction = defaultWeightingFunction(
            z: 2,
            epsilon: PositiveNonZeroFloat(floatValue: 0.0001)!
        )
        let pixelConnectivity: PixelConnectivity = .eightConnected

        // when
        let resultGrayPixelMatrix = holeFiller.grayPixelMatrixWithFilledHole(
            baseGrayPixelMatrix: baseGrayPixelMatrix,
            holeMaskGrayPixelMatrix: holeMaskGrayPixelMatrix,
            isHolePixel: isHolePixel,
            weightingFunction: weightingFunction,
            pixelConnectivity: pixelConnectivity
        )

        // then
        XCTAssertNil(resultGrayPixelMatrix)
    }

    func testGrayPixelMatrixWithFilledHole_6rows5columnsMatrixes_mustSucceed() {

        // given
        let baseWhiteFloats: [[Float]] = [
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 0.1, 1.0, 1.0],
            [1.0, 0.5, 0.2, 0.1, 1.0],
            [1.0, 0.8, 0.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0]
        ]
        let baseGrayPixelMatrix = Matrix<GrayPixel>(
            rawMatrix: baseWhiteFloats.map {
                $0.lazy
                    .map { ($0, 1.0) }
                    .map(GrayPixel.init(whiteFloat:alphaFloat:))
                    .map { $0! }
                }
        )!
        let holeMaskWhiteFloats: [[Float]] = [
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 0.0, 0.0, 1.0, 1.0],
            [1.0, 0.0, 0.0, 0.0, 1.0],
            [1.0, 1.0, 0.0, 0.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0]
        ]
        let holeMaskGrayPixelMatrix = Matrix<GrayPixel>(
            rawMatrix: holeMaskWhiteFloats.map {
                $0.lazy
                    .map { ($0, 1.0) }
                    .map(GrayPixel.init(whiteFloat:alphaFloat:))
                    .map { $0! }
            }
        )!
        let isHolePixel: (GrayPixel) -> Bool = { $0.isBlack }
        let weightingFunction: WeightingFunction = defaultWeightingFunction(
            z: 2,
            epsilon: PositiveNonZeroFloat(floatValue: 0.0001)!
        )
        let pixelConnectivity: PixelConnectivity = .eightConnected

        // when
        let resultGrayPixelMatrix = holeFiller.grayPixelMatrixWithFilledHole(
            baseGrayPixelMatrix: baseGrayPixelMatrix,
            holeMaskGrayPixelMatrix: holeMaskGrayPixelMatrix,
            isHolePixel: isHolePixel,
            weightingFunction: weightingFunction,
            pixelConnectivity: pixelConnectivity
        )

        // then
        XCTAssertNotNil(resultGrayPixelMatrix)

        let expectedWhiteFloats: [[Float]] = [
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 0.9900625, 0.9918994, 1.0, 1.0],
            [1.0, 0.9594998, 0.9740266, 0.9918994, 1.0],
            [1.0, 0.8, 0.9594999, 0.9900625, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0]
        ]
        let expectedAlphaFloats: [[Float]] = [
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0]
        ]
        let expectedWhiteAndAlphaFloats: [[(Float, Float)]] =
            zip(expectedWhiteFloats, expectedAlphaFloats)
                .map { zip($0.0, $0.1).asArray() }
        let expectedGrayPixelMatrix: Matrix<GrayPixel> =
            Matrix<(Float, Float)>(rawMatrix: expectedWhiteAndAlphaFloats)!
                .map(GrayPixel.init(whiteFloat:alphaFloat:))!
                .map { $0! }!
        let grayPixelComparisonMatrix: [[(GrayPixel, GrayPixel)]] =
            zip(resultGrayPixelMatrix!.rawMatrix, expectedGrayPixelMatrix.rawMatrix)
                .map { zip($0.0, $0.1).asArray() }
        grayPixelComparisonMatrix.forEach {
            $0.forEach { resultGrayPixelAndExpectedGrayPixel in
                let (resultGrayPixel, expectedGrayPixel)
                    = resultGrayPixelAndExpectedGrayPixel
                XCTAssertEqual(
                    resultGrayPixel.whiteFloat,
                    expectedGrayPixel.whiteFloat,
                    accuracy: 1e-6
                )
                XCTAssertEqual(
                    resultGrayPixel.alphaFloat,
                    expectedGrayPixel.alphaFloat,
                    accuracy: 1e-6
                )
            }
        }
    }
}
