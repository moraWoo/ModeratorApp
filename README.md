# ModeratorApp

ModeratorApp is a moderator application that displays users, allows managing their status, and saves changes locally.

## Features

- Loading users from API
- Local data storage using SwiftData
- Two lists: all users and administrators only
- Search by name
- Ability to assign/remove administrators
- Ability to ban/unban users
- User avatar management

## Technical Details

### Architecture and Patterns

- MVVM for business logic organization
- Coordinator Pattern for navigation
- Repository Pattern for data management
- Dependency Injection using Swinject

### Technologies and Libraries Used

- **SwiftUI** - for building user interface
- **SwiftData** - for local data storage
- **Combine** - for reactive programming
- **Moya** - for networking
- **Swinject** - for dependency injection
- **SwiftGen** - for type-safe resource management

### Why These Libraries Were Chosen:

- **Moya**: Provides type-safe and declarative approach to networking, making code more readable and testable.
- **Swinject**: Allows easy dependency management, making code more modular and testable.
- **SwiftData**: Apple's new data framework that provides high performance and seamless SwiftUI integration.
- **Combine**: Enables reactive programming and convenient asynchronous event handling.
- **SwiftGen**: Generates type-safe access to resources, preventing runtime errors.

## Development Time

- Total working time: 8 hours

## Developer Experience

- iOS development experience: 2 years

## Installation and Launch

1. Clone the repository
2. Open ModeratorApp.xcodeproj in Xcode 15.0 or higher
3. Run the project on simulator or real device with iOS 16.0 or higher

## Additional Information

The application is developed following modern iOS development approaches, focusing on scalability, testability, and code maintainability.

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
