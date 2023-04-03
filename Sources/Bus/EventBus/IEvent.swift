import Foundation

public protocol IEvent: AnyObject {
    static func identifier() -> String
}

extension IEvent {
    static func identifier() -> String {
        String(reflecting: Self.self)
    }
}


