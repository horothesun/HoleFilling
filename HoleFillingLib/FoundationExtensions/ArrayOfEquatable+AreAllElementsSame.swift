extension Array where Element: Equatable {

    var areAllElementsSame: Bool {
        if count == 0 {
            return false
        } else {
            let headElement = self[0]
            let tailElements = dropFirst().asArray()
            return tailElements
                .reduce(true) { partialResult, element -> Bool in
                    partialResult && element == headElement
                }
        }
    }
}
