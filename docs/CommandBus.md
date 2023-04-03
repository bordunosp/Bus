# CommandBus

CommandBus is a behavioral design pattern that turns a request into a stand-alone object that contains all information about the request.

This Swift package provides a simple implementation of a CommandBus. It is used to register and execute command handlers for a given command type.

---
## Usage

```swift 
import Bus
```



### Creating a command

To create a command, simply create a class that conforms to ICommand.

```swift
class MyCommand: ICommand {
    // Add any properties and methods necessary to represent the command
}
```

### Creating a command handler

A command handler is responsible for carrying out the action specified by a command. It must conform to the ICommandHandler protocol:

```swift 
public protocol ICommandHandler {
    associatedtype Command: ICommand
    var handle: (_ command: Command) async throws -> Void { get }
}
```

To create a command handler, create a class that conforms to ICommandHandler and implement the handle method:

```swift 
class MyCommandHandler: ICommandHandler {
    var handle: (_ command: MyCommand) async throws -> Void {
        // Add code to handle the command here
    }
}
```

### Registering a command handler (once in main.swift)

To register a command handler for a given command type, create an instance of the handler and pass it to the register method:

```swift
try CommandBus.register(MyCommandHandler())
```


### Executing a command

To execute a command, simply call the execute method on the CommandBus:

```swift 
try await CommandBus.execute(MyCommand())
```

If a command handler has been registered for the given command type, the handler's handle method will be called with the command as its parameter.

---

# Example

Here's an example of how to use CommandBus:

```swift
import Bus

// src: Sources/App/Application/Commands/My/MyCommand.swift
class MyCommand: ICommand {
    let parameter: String

    init(parameter: String) {
        self.parameter = parameter
    }
}

// src: Sources/App/Application/Commands/My/MyCommandHandler.swift
class MyCommandHandler: ICommandHandler {
    var handle: (_ command: MyCommand) async throws -> Void {
        print("Executing command with parameter: \(command.parameter)")
    }
}

// In the executableTarget (main.swift)
// Register the command handler
try CommandBus.register(MyCommandHandler())

// Execute the command
// Call in any of the adapters (controller, Grpc, ws, etc...)
try await CommandBus.execute(MyCommand(parameter: "Hello, world!"))

```

