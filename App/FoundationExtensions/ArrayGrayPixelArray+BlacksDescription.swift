//import HoleFillingLib

extension Array where Element == [GrayPixel] {

    var blacksDescription: String {
        if count == 0 {
            return ""
        } else {
            let firstRow = self[0]
            let tailRows = dropFirst().asArray()
            return tailRows
                .map { $0.blacksDescription }
                .reduce(firstRow.blacksDescription, { $0 + "\n" + $1 })
        }
    }
}
