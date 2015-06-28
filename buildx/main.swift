import Foundation

let term = Terminal()

term.printOut("Test Program Number: ")
let number = term.nextLine()

func selectProgram(number:Int) -> () -> Void {
    func doNothing() {
        term.printOut("Invalid Program Number '\(number)'!", newline:true)
    }

    switch number {
        case 1: return testProgram1
        case 2: return testProgram2
        case 3: return testProgram3
        case 4: return testProgram4
        case 5: return testProgram5
        case 6: return testProgram6
        default: return doNothing
    }
}

func testProgram1() {
    repeat {
        term.printOut("Please input a text format: ")
        let format = TermFormat.fromString(term.nextLine())

        guard let termFormat = format else {
            break
        }

        term.printOut("Please input a color name: ");
        let color = TermColor.fromString(term.nextLine(), format:termFormat)
        term.stdout.synchronizeFile()
        
        guard let termColor = color else {
            break
        }
        
        term.setColor(termColor)
    } while true
}

func testProgram2() {
    repeat {
        term.printOut("Please select a color ID in the range 0-255: ")
        let line = term.nextLine()

        guard let number = UInt8(line) else {
            term.printOut("Invalid Color ID '\(line)'!", newline:true)
            break
        }

        term.set256Color(number)
    } while true
}

func testProgram3() {
    repeat {
        term.printOut("Please select a color ID in the range 0-255: ")
        let line = term.nextLine()
        
        guard let number = UInt8(line) else {
            term.printOut("Invalid Color ID '\(line)'!", newline:true)
            break
        }
        
        term.set256ColorBG(number)
    } while true
}

func testProgram4() {
    for i in 0...255 {
        term.set256Color(UInt8(i))
        term.printOut("\(i)\t")

        if (i + 1) % 8 == 0 {
            term.newline()
        }
    }

    term.resetFormatting()
    term.set256Color(254)
    term.printOut(Terminal.controlChars.get("z"))

    for i in 0...255 {
        term.set256ColorBG(UInt8(i))
        term.printOut("\(i)\t")

        if (i + 1) % 8 == 0 {
            term.resetFormatting()
            term.set256Color(254)
            term.newline()
        }
    }

    term.resetFormatting()
}

func testProgram5() {
    term.printOut("Please input a filename to use: ")
    let path = term.nextLine()
    let handle = NSFileHandle(forWritingAtPath: path)

    guard let file = handle else {
        term.printOut("Could not open file at '\(path)'", newline:true, toStream:term.stderr)
        exit(EXIT_SUCCESS)
    }

    file.truncateFileAtOffset(1 << 30)
    file.synchronizeFile()
    file.closeFile()
}

func testProgram6() {
    term.printOut("Terminal Size: \(term.columns) by \(term.lines)", newline:true)
}

if let programNumber = Int(number) {
    selectProgram(programNumber)()
} else {
    selectProgram(Int.max)()
}
