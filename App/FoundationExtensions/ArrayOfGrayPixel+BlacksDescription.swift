//import HoleFillingLib

extension Array where Element == GrayPixel {

    var blacksDescription: String {
        if count == 0 {
            return ""
        } else {
            let firstPixel = self[0]
            let tailPixels = dropFirst().asArray()
            return tailPixels
                .map { $0.blackDescription }
                .reduce(firstPixel.blackDescription, { $0 + " " + $1 })
        }
    }
}
