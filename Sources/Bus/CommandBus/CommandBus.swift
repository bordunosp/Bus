import Foundation

public final class CommandBus {
    private static var _commandsLock = NSLock()
    private static var _commands = [String: Any]()

    /**
     Registers a command handler for a given command type.

     - Parameter handler: The command handler to register.
     - Throws: An exception if the command is already registered.
    */
    public static func register<Handler: ICommandHandler>(_ handler: Handler) throws {
        _commandsLock.lock()
        defer {
            _commandsLock.unlock()
        }
        guard _commands[Handler.Command.identifier()] == nil else {
            throw CommandBusError.alreadyRegistered
        }
        _commands[Handler.Command.identifier()] = handler.handle
    }

    /**
     Executes a given command.

     - Parameter command: The command to execute.
     - Throws: An exception if the command is not registered or if the command handler has an incorrect type.
    */
    public static func execute<T: ICommand>(_ command: T) async throws {
        guard let handler = _commands[T.identifier()] else {
            throw CommandBusError.notRegistered
        }
        guard let handler = handler as? (_ command: T) async throws -> Void else {
            throw CommandBusError.incorrectType
        }
        try await handler(command)
    }
}
