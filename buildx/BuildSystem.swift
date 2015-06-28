import Foundation

public class XBSBuildSystem {
    static let version = 2.0
    static let name = "XBS"
    
    var settings:Dictionary<String, String>?
    var project:String
    
    public init(project:String, settings:Dictionary<String, String>?) {
        self.settings = settings
        self.project = project
    }
}
