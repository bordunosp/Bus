import Foundation

public final class QueryBus {
    private static var _queriesLock = NSLock()
    private static var _queries = [String: Any]()

    public static func register<Handler: IQueryHandler>(_ handler: Handler) throws {
        _queriesLock.lock()
        defer {
            _queriesLock.unlock()
        }
        guard _queries[Handler.QueryRequest.identifier()] == nil else {
            throw QueryBusError.alreadyRegistered
        }
        _queries[Handler.QueryRequest.identifier()] = handler.handle
    }

    public static func handle<T: IQuery, QueryResponse>(_ query: T) async throws -> QueryResponse {
        guard let handler = _queries[T.identifier()] else {
            throw QueryBusError.notRegistered
        }
        guard let handler = handler as? (_ query: T) async throws -> QueryResponse else {
            throw QueryBusError.incorrectType
        }
        return try await handler(query)
    }
}
