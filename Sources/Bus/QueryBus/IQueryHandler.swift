import Foundation

public protocol IQueryHandler {
    associatedtype QueryRequest: IQuery
    associatedtype QueryResponse: Any
    var handle: (_ query: QueryRequest) async throws -> QueryResponse { get }
}
