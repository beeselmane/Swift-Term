import Foundation
import Darwin

public enum TermFormat : Int {
    case Normal     = 0
    case Bright     = 1
    case Dim        = 2
    case Underline  = 4
    case Blink      = 5
    case Reverse    = 7
    case Hidden     = 8

    static func fromString(string:String) -> TermFormat? {
        switch string.lowercaseString {
        case "normal":    return .Normal
        case "bright":    return .Bright
        case "bold":      return .Bright
        case "dim":       return .Dim
        case "underline": return .Underline
        case "blink":     return .Blink
        case "reverse":   return .Reverse
        case "hidden":    return .Hidden
        default:          return nil
        }
    }

    func formatCode() -> String {
        return "\u{1B}\(self.rawValue)m"
    }

    static func resetCode() -> String {
        return "\u{1B}(B\u{1B}[m"
    }
}

public enum TermColor {
    case Black(TermFormat)
    case Red(TermFormat)
    case Green(TermFormat)
    case Yellow(TermFormat)
    case Blue(TermFormat)
    case Magenta(TermFormat)
    case Cyan(TermFormat)
    case White(TermFormat)
    case Default(TermFormat)

    var data:(colorCode:UInt8, format:TermFormat) {
        switch self {
        case .Black(let format):   return (0, format)
        case .Red(let format):     return (1, format)
        case .Green(let format):   return (2, format)
        case .Yellow(let format):  return (3, format)
        case .Blue(let format):    return (4, format)
        case .Magenta(let format): return (5, format)
        case .Cyan(let format):    return (6, format)
        case .White(let format):   return (7, format)
        case .Default(let format): return (9, format)
        }
    }

    var rawValue:String {
        get {
            let (code, format) = self.data
            return "\u{1B}[\(format.rawValue);3\(code)m"
        }
    }

    private func makeCode(normal normal:UInt8, bright:UInt8) -> String? {
        let (code, format) = self.data
        var realCode:UInt8
        
        switch format {
        case .Normal: realCode = normal
        case .Bright: realCode = bright
        default: return nil
        }
        
        return "\u{1B}[\(realCode)\(code)"
    }

    func colorCode() -> String? {
        return self.makeCode(normal: 3, bright: 9)
    }

    func backgroundColorCode() -> String? {
        return self.makeCode(normal: 4, bright: 10)
    }

    static func fromString(string:String, format:TermFormat = .Normal) -> TermColor? {
        switch string.lowercaseString {
        case "black":       return .Black(format)
        case "red":         return .Red(format)
        case "green":       return .Green(format)
        case "yellow":      return .Yellow(format)
        case "blue":        return .Blue(format)
        case "magenta":     return .Magenta(format)
        case "cyan":        return .Cyan(format)
        case "white":       return .White(format)
        default:            return nil
        }
    }
}

class Terminal {
    static let controlChars:Dictionary<Character, Character> = [
        "A" : "\u{01}", "B" : "\u{02}", "C" : "\u{03}", "D" : "\u{04}",
        "E" : "\u{05}", "F" : "\u{06}", "G" : "\u{07}", "H" : "\u{08}",
        "I" : "\u{09}", "J" : "\u{0A}", "K" : "\u{0B}", "L" : "\u{0C}",
        "M" : "\u{0D}", "N" : "\u{0E}", "O" : "\u{0F}", "P" : "\u{10}",
        "Q" : "\u{11}", "R" : "\u{12}", "S" : "\u{13}", "T" : "\u{14}",
        "U" : "\u{15}", "V" : "\u{16}", "W" : "\u{17}", "X" : "\u{18}",
        "Y" : "\u{19}", "Z" : "\u{1A}", "[" : "\u{1B}", "\\" : "\u{1C}",
        "]" : "\u{1D}", "^" : "\u{1E}", "_" : "\u{1F}"
    ]

    let devnull = NSFileHandle.fileHandleWithNullDevice()
    let stderr = NSFileHandle.fileHandleWithStandardError()
    let stdout = NSFileHandle.fileHandleWithStandardOutput()
    let stdin = NSFileHandle.fileHandleWithStandardInput()

    var size:(columns:Int, lines:Int) {
        get {
            updateTermInfo()
            return (Int(termColums()), Int(termRows()))
        }
    }

    var columns:Int {
        get {
            let (cols, _) = size
            return cols
        }
    }

    var lines:Int {
        get {
            let (_, lin) = size
            return lin
        }
    }

    func nextLine(onStream stream:NSFileHandle = NSFileHandle.fileHandleWithStandardInput()) -> String {
        let fullLine = NSString(data: stream.availableData, encoding: NSUTF8StringEncoding)! as String
        return fullLine.substringToIndex(fullLine.endIndex.predecessor())
    }

    func printOut<T>(line:T, newline:Bool = false, toStream stream:NSFileHandle = NSFileHandle.fileHandleWithStandardOutput()) {
        stream.writeData(String(line).dataUsingEncoding(NSUTF8StringEncoding)!)
        if newline { stream.writeData("\n".dataUsingEncoding(NSUTF8StringEncoding)!) }
    }

    func newline(onStream stream:NSFileHandle = NSFileHandle.fileHandleWithStandardOutput()) {
        stdout.writeData("\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    }

    func setColor(color:TermColor) {
        self.printOut(color.rawValue, newline:false)
    }

    func setColorOnly(color:TermColor) {
        let code = color.colorCode()
        
        if let cCode = code {
            self.printOut(cCode, newline:false)
        }
    }

    func setFormat(format:TermFormat) {
        self.printOut(format.formatCode(), newline:false)
    }

    func resetFormatting() {
        self.printOut(TermFormat.resetCode(), newline:false)
    }

    func setBackground(color:TermColor) {
        let code = color.backgroundColorCode()
        
        if let bgCode = code {
            self.printOut(bgCode, newline:false)
        }
    }

    func set256Color(color:UInt8) {
        self.printOut("\u{1B}[38;5;\(color)m", newline:false)
    }

    func set256ColorBG(color:UInt8) {
        self.printOut("\u{1B}[48;5;\(color)m", newline:false)
    }
}
