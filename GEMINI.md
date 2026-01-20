# Remind Me

## Project Overview

**Remind Me** is a simple daily reminder application built with Flutter. It utilizes `Hive` for local data storage and `flutter_local_notifications` for scheduling and displaying notifications. The app adheres to Material Design standards.

### Key Technologies

*   **Flutter:** Cross-platform UI toolkit.
*   **Hive:** Lightweight and fast key-value database for local storage.
*   **Flutter Local Notifications:** Plugin for displaying local notifications on Android and iOS.
*   **GetIt:** Service locator for dependency injection.
*   **Intl & Timezone:** For date and time formatting and handling timezones.

### Architecture

The project follows a standard Flutter application structure:

*   **`lib/main.dart`**: The application entry point. It initializes Hive and the Notification Service, sets up dependency injection, and runs the main `App` widget.
*   **`lib/services/`**: Contains core business logic and external system integrations.
    *   `hive_service.dart`: Manages CRUD operations for tasks using Hive.
    *   `notification_service.dart`: Handles initialization, permission requests, and scheduling of local notifications.
*   **`lib/pages/`**: Contains the application's screens (e.g., `home_page.dart`).
*   **`lib/widgets/`**: Reusable UI components.
*   **`lib/task.dart`**: Defines the `Task` data model and its Hive adapter.

## Building and Running

### Prerequisites

*   Flutter SDK (version `^3.10.7` as per `pubspec.yaml`)
*   Dart SDK

### Key Commands

*   **Install Dependencies:**
    ```bash
    flutter pub get
    ```

*   **Run Development Server:**
    ```bash
    flutter run
    ```

*   **Run Tests:**
    ```bash
    flutter test
    ```

*   **Code Generation (Hive Adapters):**
    This project uses `build_runner` to generate Hive adapters. Run this command after modifying `task.dart` or other Hive entities.
    ```bash
    dart run build_runner build
    ```
    Or to watch for changes:
    ```bash
    dart run build_runner watch
    ```

## Development Conventions

*   **Dependency Injection:** Use `GetIt` to access singletons like `NotificationService` and `HiveService`.
*   **Local Storage:** All persistent data should be stored in Hive boxes.
*   **Notifications:** Notifications are scheduled based on task properties. Ensure `NotificationService` is updated if task scheduling logic changes.
*   **Theming:** The app uses `Material 3` with a seed color (`Color(0xFFCD853F)`).

## Directory Structure

*   `android/`, `ios/`, `web/`, `linux/`: Platform-specific configuration and build files.
*   `lib/`: Main source code.
*   `test/`: Unit and widget tests (standard Flutter convention).
