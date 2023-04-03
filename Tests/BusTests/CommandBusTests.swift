import XCTest
@testable import Bus


class MockCommand: ICommand {}
class MockCommand2: ICommand {}
class MockCommand3: ICommand {
    static var executed: Bool = false
}
class NotRegisteredMockCommand: ICommand {}
class MockCommand4: ICommand {}

class MockCommandHandler: ICommandHandler {
    var handle: (MockCommand) async throws -> Void = { _ in }
}
class MockCommandHandler2: ICommandHandler {
    var handle: (MockCommand2) async throws -> Void = { _ in }
}
class MockCommandHandler3: ICommandHandler {
    var handle: (_ command: MockCommand3) async throws -> Void = { command in
        MockCommand3.executed = true
    }
}
class MockCommandHandler4: ICommandHandler {
    var handle: (MockCommand4) async throws -> Void = { _ in }
}

class CommandBusTests: XCTestCase {
    func testRegisterHandler() {
        XCTAssertNoThrow(try CommandBus.register(MockCommandHandler()))
    }

    func testRegisterAlreadyRegisteredHandler() {
        XCTAssertNoThrow(try CommandBus.register(MockCommandHandler2()))
        XCTAssertThrowsError(try CommandBus.register(MockCommandHandler2()), "Handler should already be registered") { error in
            XCTAssertEqual(error as? CommandBusError, CommandBusError.alreadyRegistered)
        }
    }

    func testHandleRegisteredQuery() async throws {
        XCTAssertFalse(MockCommand3.executed)

        try CommandBus.register(MockCommandHandler3())

        do {
            try await CommandBus.execute(MockCommand3())
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        XCTAssertTrue(MockCommand3.executed)
    }

    func testHandleNotRegisteredQuery() async throws {
        do {
            try await CommandBus.execute(NotRegisteredMockCommand())
            XCTFail("expected error")
        } catch let error as CommandBusError {
            XCTAssertTrue(error == CommandBusError.notRegistered)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testQueryIdentifier() {
        XCTAssertEqual(MockCommand.identifier(), "BusTests.MockCommand")
        XCTAssertEqual(MockCommand2.identifier(), "BusTests.MockCommand2")
        XCTAssertEqual(MockCommand3.identifier(), "BusTests.MockCommand3")
        XCTAssertEqual(MockCommand4.identifier(), "BusTests.MockCommand4")
        XCTAssertEqual(NotRegisteredMockCommand.identifier(), "BusTests.NotRegisteredMockCommand")
    }
}
