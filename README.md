# Remind Me

**Remind Me** is a simple yet powerful daily reminder application built with Flutter. It helps you keep track of your tasks and notifies you daily to ensure you never miss an important activity. The app leverages `Hive` for efficient local storage and `flutter_local_notifications` for reliable scheduling.

## Features

*   **Task Management:** Create, read, update, and delete tasks.
*   **Daily Reminders:** Schedule notifications to remind you of your tasks every weekday.
*   **Prioritization:** Assign priority levels (Low, Medium, High) to your tasks.
*   **Local Storage:** All data is stored locally on your device for privacy and speed.
*   **Material Design:** A clean and modern UI following Material 3 guidelines.

## Key Technologies

*   **[Flutter](https://flutter.dev):** Cross-platform UI toolkit.
*   **[Hive](https://docs.hivedb.dev/):** Lightweight and fast key-value database for local storage.
*   **[Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications):** Plugin for displaying local notifications on Android and iOS.
*   **[GetIt](https://pub.dev/packages/get_it):** Service locator for dependency injection.
*   **[Intl](https://pub.dev/packages/intl) & [Timezone](https://pub.dev/packages/timezone):** For robust date and time formatting and timezone handling.

## Getting Started

### Prerequisites

*   **Flutter SDK:** Version `^3.10.7` or higher.
*   **Dart SDK:** Compatible with the Flutter version.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/remindme.git
    cd remindme
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Generate Hive Adapters:**
    The project uses code generation for Hive adapters. Run the following command:
    ```bash
    dart run build_runner build
    ```
    To automatically rebuild on changes, use:
    ```bash
    dart run build_runner watch
    ```

4.  **Run the application:**
    ```bash
    flutter run
    ```

## Testing

The project includes a suite of unit tests to ensure reliability.

To run the tests:
```bash
flutter test
```

## Architecture

The project follows a clean and standard Flutter application structure:

*   **`lib/main.dart`**: Entry point. Initializes services (Hive, Notifications) and dependency injection.
*   **`lib/services/`**:
    *   `hive_service.dart`: Handles all database interactions (CRUD operations).
    *   `notification_service.dart`: Manages notification permissions and scheduling logic.
*   **`lib/pages/`**: UI screens (e.g., `HomePage`, `TaskPage`).
*   **`lib/widgets/`**: Reusable UI components like `TaskCard`.
*   **`lib/task.dart`**: The core data model and its Hive adapter.

## Contributing

Contributions are welcome! Please follow these guidelines:

1.  **Code Style:** Adhere to the existing Flutter and Dart style conventions.
2.  **Tests:** Ensure all new features or bug fixes are covered by unit tests.
3.  **Conventions:**
    *   Use `GetIt` for accessing `NotificationService` and `HiveService`.
    *   Store persistent data in Hive.
    *   Follow Material 3 design principles (Seed Color: `Color(0xFFCD853F)`).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.