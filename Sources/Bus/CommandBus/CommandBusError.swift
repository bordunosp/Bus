import Foundation

public enum CommandBusError: Error {
    case alreadyRegistered
    case notRegistered
    case incorrectType
}
