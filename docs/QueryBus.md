# QueryBus

QueryBus is a behavioral design pattern that turns a request for information into a stand-alone object that contains all information about the request.

This Swift package provides a simple implementation of a QueryBus. It is used to register and execute query handlers for a given query type.

## Usage
```swift 
import Bus
```

## Creating a query

To create a query, simply create a class that conforms to IQuery.

```swift
class MyQuery: IQuery {
    // Add any properties and methods necessary to represent the query
} 
```

## Creating a query handler

A query handler is responsible for returning the result specified by a query. It must conform to the IQueryHandler protocol:

```swift
public protocol IQueryHandler {
    associatedtype QueryRequest: IQuery
    associatedtype QueryResponse: Any
    var handle: (_ query: QueryRequest) async throws -> QueryResponse { get }
}
```

To create a query handler, create a class that conforms to IQueryHandler and implement the handle method:

```swift
class MyQueryHandler: IQueryHandler {
    var handle: (_ query: MyQuery) async throws -> Any {
        // Add code to handle the query here and return the result
    }
}
```

## Registering a query handler (once in main.swift)

To register a query handler for a given query type, create an instance of the handler and pass it to the register method:

```swift
try QueryBus.register(MyQueryHandler())
```

## Executing a query

To execute a query, simply call the handle method on the QueryBus:

```swift
let result = try await QueryBus.handle(MyQuery())
```

If a query handler has been registered for the given query type, the handler's handle method will be called with the query as its parameter and will return the result of the query.

# Example

Here's an example of how to use QueryBus:

```swift 
import Bus

// src: Sources/App/Application/Queries/My/MyQueryRequest.swift
class MyQueryRequest: IQuery {
    let parameter: String

    init(parameter: String) {
        self.parameter = parameter
    }
}

// src: Sources/App/Application/Queries/My/MyQueryResponse.swift
class MyQueryResponse: IQuery {
    let parameter: String

    init(parameter: String) {
        self.parameter = parameter
    }
}

// src: Sources/App/Application/Queries/My/MyQueryHandler.swift
class MyQueryHandler: IQueryHandler {
    var handle: (_ query: MyQueryRequest) async throws -> MyQueryResponse {
        return MyQueryResponse(parameter: MyQueryRequest.parameter)
    }
}

// In the executableTarget (main.swift)
// Register the query handler
try QueryBus.register(MyQueryHandler())

// Execute the query
// Call in any of the adapters (controller, Grpc, ws, etc...)
let result: MyQueryResponse = try await QueryBus.handle(MyQuery(parameter: "Hello, world!"))

print(result.parameter)
```