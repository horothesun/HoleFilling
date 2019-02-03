# HoleFilling

* Modules
    * HoleFiller: command line macOS app,
    * App: main app behaviour,
    * InputValidation: applicative-based input `​String​`s validation logic and
    * HoleFillingLib: main hole filling algorithm.

* Unit tests for​ `HoleFiller​`and​ `InputValidator` ​can be executed from the `HoleFilling​` scheme.

* One of the arguments of the main hole filling algorithm is the function `isHolePixel: (GrayPixel) -> Bool`,​ used to determine if a pixel of the hole mask grayscale matrix is part of the hole.

* Command line macOS app inputs
    * RGB base image absolute path
    * RGB hole mask image absolute path (hole represented by black pixels)
    * default weighting function 'z' parameter
    * default weighting function 'epsilon' parameter
    * pixel connectivity ('4' or '8')
    * output image absolute path.

* Running the​ `HoleFilling`​ scheme in Xcode prints out the app build path, useful to locate the executable and test the app via command line.
