import Foundation

public typealias WeightingFunction = (Coordinate2D, Coordinate2D) -> Float

public func defaultWeightingFunction(
    z: Float,
    epsilon: PositiveNonZeroFloat) -> WeightingFunction {

    return { u, v -> Float in
        1.0 / (powf(u.euclideanDistance(from: v), z) + epsilon.floatValue)
    }
}
