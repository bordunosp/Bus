import Foundation

public protocol ICommand: AnyObject {
    static func identifier() -> String
}

public extension ICommand {
    static func identifier() -> String {
        String(reflecting: Self.self)
    }
}

