import Foundation

public protocol IQuery: AnyObject {
    static func identifier() -> String
}

extension IQuery {
    static func identifier() -> String {
        String(reflecting: Self.self)
    }
}
