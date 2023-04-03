import XCTest
@testable import Bus

final class QueryBusTests: XCTestCase {
    func testRegisterHandler() {
        XCTAssertNoThrow(try QueryBus.register(MockQueryHandler()))
    }

    func testRegisterAlreadyRegisteredHandler() {
        XCTAssertNoThrow(try QueryBus.register(MockQueryHandler2()))
        XCTAssertThrowsError(try QueryBus.register(MockQueryHandler2()), "Handler should already be registered") { error in
            XCTAssertEqual(error as? QueryBusError, QueryBusError.alreadyRegistered)
        }
    }

    func testHandleRegisteredQuery() async throws {
        try QueryBus.register(MockQueryHandler3())
        let response: String = try await QueryBus.handle(MockQuery3())
        XCTAssertEqual(response, "Mock response 3")
    }

    func testHandleNotRegisteredQuery() async throws {
        do {
            _ = try await QueryBus.handle(NotRegisteredMockQuery()) as NotRegisteredMockQuery
            XCTFail("expected error")
        } catch let error as QueryBusError {
            XCTAssertTrue(error == QueryBusError.notRegistered)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testHandleIncorrectTypeQuery() async throws {
        try QueryBus.register(MockQueryHandler4())

        do {
            _ = try await QueryBus.handle(MockQuery4()) as QueryBusTests
            XCTFail("expected error")
        } catch let error as QueryBusError {
            XCTAssertTrue(error == QueryBusError.incorrectType)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testQueryIdentifier() {
        XCTAssertEqual(MockQuery.identifier(), "BusTests.MockQuery")
        XCTAssertEqual(MockQuery2.identifier(), "BusTests.MockQuery2")
        XCTAssertEqual(MockQuery3.identifier(), "BusTests.MockQuery3")
        XCTAssertEqual(MockQuery4.identifier(), "BusTests.MockQuery4")
        XCTAssertEqual(NotRegisteredMockQuery.identifier(), "BusTests.NotRegisteredMockQuery")
    }

}

class MockQueryHandler: IQueryHandler {
    var handle: (_ query: MockQuery) async throws -> String = { query in
        "Mock response"
    }
}
class MockQueryHandler2: IQueryHandler {
    var handle: (_ query: MockQuery2) async throws -> String = { query in
        "Mock response 2"
    }
}
class MockQueryHandler3: IQueryHandler {
    var handle: (_ query: MockQuery3) async throws -> String = { query in
        "Mock response 3"
    }
}
class MockQueryHandler4: IQueryHandler {
    var handle: (_ query: MockQuery4) async throws -> String = { query in
        "Mock response 4"
    }
}


class MockQuery: IQuery {}
class MockQuery2: IQuery {}
class MockQuery3: IQuery {}
class MockQuery4: IQuery {}
class NotRegisteredMockQuery: IQuery {}