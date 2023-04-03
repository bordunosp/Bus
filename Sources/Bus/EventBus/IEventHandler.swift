import Foundation

public protocol IEventHandler {
    associatedtype Event: IEvent
    var handle: (_ event: Event) async throws -> Void { get }
}
