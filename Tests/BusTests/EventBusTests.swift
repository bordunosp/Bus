import XCTest
@testable import Bus

class MockEvent: IEvent {
    static var executed2: Bool = false
    static var executed3: Bool = false
}
class NotRegisteredMockEvent: IEvent {}

class MockEventHandler: IEventHandler {
    var handle: (MockEvent) async throws -> Void = { _ in }
}
class MockEventHandler2: IEventHandler {
    var handle: (_ event: MockEvent) async throws -> Void = { event in
        MockEvent.executed2 = true
    }
}
class MockEventHandler3: IEventHandler {
    var handle: (_ event: MockEvent) async throws -> Void = { event in
        MockEvent.executed3 = true
    }
}



final class EventBusTests: XCTestCase {
    func testRegisterHandler() {
        XCTAssertNoThrow(try EventBus.register(MockEventHandler()))
    }


    func testHandleRegisteredQuery() async throws {
        XCTAssertFalse(MockEvent.executed2)
        XCTAssertFalse(MockEvent.executed3)

        try EventBus.register(MockEventHandler2())
        try EventBus.register(MockEventHandler3())

        do {
            try await EventBus.execute(MockEvent())
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        XCTAssertTrue(MockEvent.executed2)
        XCTAssertTrue(MockEvent.executed3)
    }
}
