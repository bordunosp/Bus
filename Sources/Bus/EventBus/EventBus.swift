import Foundation

public class EventBus {
    private static var _eventsLock = NSLock()
    private static var _events = [String: [Any]]()

    /**
     Registers an event handler for a given event type.

     - Parameter handler: The event handler to register.
     - Throws: `EventBusError.alreadyRegistered` if the given handler has already been registered for the given event type.
     */
    public static func register<Handler: IEventHandler>(_ handler: Handler) throws {
        _eventsLock.lock()
        defer {
            _eventsLock.unlock()
        }
        _events[Handler.Event.identifier(), default: []].append(handler.handle)
    }

    /**
     Executes all registered event handlers for a given event.

     - Parameter event: The event to execute handlers for.
     - Throws: Any error thrown by the event handlers.
     */
    public static func execute<T: IEvent>(_ event: T) async throws {
        if _events[T.identifier(), default: []].isEmpty {
            return
        }

        try await withThrowingTaskGroup(of: Void.self) { taskGroup in
            for handler in _events[T.identifier(), default: []] {
                taskGroup.addTask {
                    guard let handler = handler as? (_ event: T) async throws -> Void else {
                        throw EventBusError.incorrectType
                    }
                    try await handler(event)
                }
            }
            try await taskGroup.waitForAll()
        }
    }
}
