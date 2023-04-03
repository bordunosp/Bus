# EventBus

EventBus is a behavioral design pattern that allows for loosely coupled communication between objects.

This Swift package provides a simple implementation of an EventBus. It is used to register and execute event handlers for a given event type.

## Usage

```swift 
import Bus
```

## Creating an event

To create an event, simply create a class that conforms to IEvent:

```swift 
class MyEvent: IEvent {
    // Add any properties and methods necessary to represent the event
}
```

## Creating an event handler

An event handler is responsible for responding to an event. It must conform to the IEventHandler protocol:

```swift
public protocol IEventHandler {
    associatedtype Event: IEvent
    var handle: (_ event: Event) async throws -> Void { get }
}
```

To create an event handler, create a class that conforms to IEventHandler and implement the handle method:

```swift
class MyEventHandler: IEventHandler {
    var handle: (_ event: MyEvent) async throws -> Void {
        // Add code to handle the event here
    }
}
```

## Registering an event handler (once in main.swift)

To register an event handler for a given event type, create an instance of the handler and pass it to the register method:

```swift
try EventBus.register(MyEventHandler())
```

## Executing an event

To execute an event, simply call the execute method on the EventBus:

```swift
try await EventBus.execute(MyEvent())
```

If an event handler has been registered for the given event type, the handler's handle method will be called with the event as its parameter.

---

# Example

Here's an example of how to use EventBus:

```swift
import Bus

// src: Sources/App/Domain/Events/MyEvent.swift
class MyEvent: IEvent {
    let parameter: String

    init(parameter: String) {
        self.parameter = parameter
    }
}

// src: Sources/App/Application/Events/My/MyFirstHandler.swift
class MyFirstHandler: IEventHandler {
    var handle: (_ event: MyEvent) async throws -> Void {
        print("First handling event with parameter: \(event.parameter)")
    }
}

// src: Sources/App/Application/Events/My/MySecondHandler.swift
class MySecondHandler: IEventHandler {
    var handle: (_ event: MyEvent) async throws -> Void {
        print("Second handling event with parameter: \(event.parameter)")
    }
}

// In the executableTarget (main.swift)
// Register the event handler
try EventBus.register(MyFirstHandler())
try EventBus.register(MySecondHandler())

// Execute the event
// Call in any part of the code where the event should be raised
try await EventBus.execute(MyEvent(parameter: "Hello, world!"))
```