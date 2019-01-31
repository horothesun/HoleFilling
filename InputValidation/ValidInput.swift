//import HoleFillingLib

public struct ValidInput {
    let rgbBaseImageAbsolutePath: String
    let rgbHoleMaskImageAbsolutePath: String
    let z: Float
    let epsilon: PositiveNonZeroFloat
    let pixelConnectivity: PixelConnectivity
    let outputImageAbsolutePath: String
}

extension ValidInput: Equatable {

    public static func == (lhs: ValidInput,rhs: ValidInput) -> Bool {

        let floatComparisonAccuracy: Float = 1e-4

        let isRGBBaseImageAbsolutePathSame
            = lhs.rgbBaseImageAbsolutePath == rhs.rgbBaseImageAbsolutePath
        let isHoleMaskImageAbsolutePathSame
            = lhs.rgbHoleMaskImageAbsolutePath == rhs.rgbHoleMaskImageAbsolutePath
        let isZAlmostSame = lhs.z >= rhs.z - floatComparisonAccuracy
            || lhs.z <= rhs.z + floatComparisonAccuracy
        let isEpsilonAlmostSame
            = lhs.epsilon.floatValue >= rhs.epsilon.floatValue - floatComparisonAccuracy
                || lhs.epsilon.floatValue <= rhs.epsilon.floatValue + floatComparisonAccuracy
        let isPixelConnectivitySame = lhs.pixelConnectivity == rhs.pixelConnectivity
        let isOutputImageAbsolutePathSame
            = lhs.outputImageAbsolutePath == rhs.outputImageAbsolutePath

        return isRGBBaseImageAbsolutePathSame
            && isHoleMaskImageAbsolutePathSame
            && isZAlmostSame
            && isEpsilonAlmostSame
            && isPixelConnectivitySame
            && isOutputImageAbsolutePathSame
    }
}
