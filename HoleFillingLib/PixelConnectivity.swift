public enum PixelConnectivity {
    case fourConnected
    case eightConnected
}

func neighbourCoordinates(
    accordingTo pixelConnectivity: PixelConnectivity)
    -> (_ center: Coordinate2D) -> [Coordinate2D] {

    switch pixelConnectivity {
    case .fourConnected:
        return neighbour4ConnectedCoordinates(center:)
    case .eightConnected:
        return neighbour8ConnectedCoordinates(center:)
    }
}

private func neighbour4ConnectedCoordinates(center: Coordinate2D) -> [Coordinate2D] {
    return [
        (center.i, center.j - 1),
        (center.i, center.j + 1),
        (center.i - 1, center.j),
        (center.i + 1, center.j)
    ].map(Coordinate2D.init(i:j:))
}

private func neighbour8ConnectedCoordinates(center: Coordinate2D) -> [Coordinate2D] {
    return [
        (center.i, center.j - 1),
        (center.i, center.j + 1),
        (center.i - 1, center.j - 1),
        (center.i - 1, center.j),
        (center.i - 1, center.j + 1),
        (center.i + 1, center.j - 1),
        (center.i + 1, center.j),
        (center.i + 1, center.j + 1)
    ].map(Coordinate2D.init(i:j:))
}
