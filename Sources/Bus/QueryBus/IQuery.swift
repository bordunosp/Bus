import Foundation

public protocol IQuery: AnyObject {
    static func identifier() -> String
}

public extension IQuery {
    static func identifier() -> String {
        String(reflecting: Self.self)
    }
}
