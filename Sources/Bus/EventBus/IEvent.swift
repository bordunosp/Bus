import Foundation

public protocol IEvent: AnyObject {
    static func identifier() -> String
}

public extension IEvent {
    static func identifier() -> String {
        String(reflecting: Self.self)
    }
}


