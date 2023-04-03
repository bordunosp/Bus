import Foundation

public protocol ICommandHandler {
    associatedtype Command: ICommand
    var handle: (_ command: Command) async throws -> Void { get }
}