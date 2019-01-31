import AppKit
//import App

/* Command line example:

 ./HoleFilling \
   "/Users/<username>/Desktop/base.jpg" \
   "/Users/<username>/Desktop/holeMask.jpg" \
   2 \
   0.001 \
   8 \
   "/Users/<username>/Desktop/out.tiff"
*/


if let appPath = CommandLine.arguments.first {
    print("📂 App path: " + appPath + "\n")
}

let app = buildAppType()
app.main(arguments: CommandLine.arguments)
