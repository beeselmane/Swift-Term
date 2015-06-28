import Foundation

public class Swift {
    static let version:Double! = 2.0

    static func OSName() -> String {
        return "Mac OS X"
    }

    static func OSVersion() -> String {
        return NSProcessInfo().operatingSystemVersionString
    }

    static func logVersion(programVersion:Double, forProgram program:String) {
        print("\(program) v\(programVersion) running with \(XBSBuildSystem.name) v\(XBSBuildSystem.version)")
        print("Running swift v\(Swift.version) on \(Swift.OSName()) \(Swift.OSVersion())")
    }
}

extension Dictionary {
    mutating func put(value:Value, atKey key:Key) {
        self[key] = value
    }
    
    mutating func put(key key:Key, value:Value) {
        self[key] = value
    }

    func get(key:Key) -> Value {
        return self[key]!
    }
}

func coordString(tuple:(Int, Int)) -> String {
    let (x, y) = tuple
    return "(\(x), \(y))"
}
