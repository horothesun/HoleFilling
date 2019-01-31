import Foundation

public struct Coordinate2D {

    public let i, j: Int

    public init(i: Int, j: Int) {
        self.i = i
        self.j = j
    }

    public func euclideanDistance(from rhs: Coordinate2D) -> Float {
        let iDistance: Int = i - rhs.i
        let jDistance: Int = j - rhs.j
        let sqrIDistance = Float(iDistance * iDistance)
        let sqrJDistance = Float(jDistance * jDistance)
        return sqrtf(sqrIDistance + sqrJDistance)
    }
}

extension Coordinate2D: Hashable {

    public static func == (lhs: Coordinate2D, rhs: Coordinate2D) -> Bool {
        return lhs.i == rhs.i && lhs.j == rhs.j
    }

    public var hashValue: Int { return i.hashValue ^ j.hashValue }
}
