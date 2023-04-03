
# Command Query Event Bus

This package provides an implementation of three behavioral design patterns: CommandBus, QueryBus, and EventBus.

- [CommandBus](https://github.com/bordunosp/bus/blob/main/docs/CommandBus.md) - turns a request into a stand-alone object that contains all information about the request. This pattern separates the request for an action from the object that will perform the action. The CommandBus receives the request and routes it to the appropriate handler, which performs the action.


- [QueryBus](https://github.com/bordunosp/bus/blob/main/docs/QueryBus.md) - is similar to the CommandBus pattern, but instead of performing an action, it returns data in the form of an object structure that can be interpreted into a SQL query.


- [EventBus](https://github.com/bordunosp/bus/blob/main/docs/EventBus.md) - provides a communication channel between components of an application. This pattern allows different parts of the system to communicate with each other via events.


By using these patterns, you can decouple the code responsible for processing requests from the code responsible for performing the requested action or returning data. This can improve the flexibility, maintainability, and scalability of your codebase.


## Installation

---

You can use Swift Package Manager (SPM). Just add the following line to your Package.swift file:


```swift 
dependencies: [
    .package(url: "https://github.com/bordunosp/bus.git", from: "1.0.1")
]
```

---

# #StandForUkraine 🇺🇦

This project aims to show support for Ukraine and its people amidst a war that has been ongoing since 2014. This war has a genocidal nature and has led to the deaths of thousands, injuries to millions, and significant property damage. We believe that the international community should focus on supporting Ukraine and ensuring security and freedom for its people.

Join us and show your support using the hashtag #StandForUkraine. Together, we can help bring attention to the issues faced by Ukraine and provide aid.

