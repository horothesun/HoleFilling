//import HoleFillingLib
//import InputValidator

public protocol AppType {
    func main(arguments commandLineArguments: [String])
}

public func buildAppType() -> AppType {
    return App(
        holeFiller: buildHoleFillerType(),
        validator: buildInputValidatorType()
    )
}
