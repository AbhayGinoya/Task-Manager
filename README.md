## [Features]

* Authentication & Authorization: Firebase Authentication for user registration, login, forgot passsword and logout.
* Firestore Integration: Store and retrieve a list of items (tasks/notes) from Firestore.
* Offline Caching: Use Drift for local caching and offline access.
* Data Syncing: Sync changes between Firestore and the local database.
* CRUD Operations: Add, delete, update,and display tasks/notes.
* Navigation: Use go_router for navigation between screens.
* User: Change user email and logout.

## [Technologies & Packages Used]

## **Dependencies**

* Firebase Core: Config firebase setup.
* Firebase Auth: Firebase authentication for login and registration.
* Firestore: Firebase Firestore for storing and retrieving data.
* Drift: Local database for offline data storage.
* Path Provider: Save local database.
* Flutter Secure Storage: Save user email and password locally with secure .
* intl: Date format.
* workmanager : Sync data firebase to local and local to server.
* Riverpod: State management library for managing app state.
* go_router: A declarative routing package for Flutter.
* MVVM & Clean Architecture: Architectural pattern for maintainability and scalability.
* Flutter: The UI framework used for the app development.

## **Dev Dependencies**

* Drift Dev : Drift Database Support
* Build Runner : Generate default code (drift and mock)
* Sqlite3 Flutter Libs : Local database native file setup.
* Mockito : Test case.
* Firebase Auth Mocks: Test Case

## **Font Family**

* JetBrainsMono 
* Pacifico - Regular

## [Setup Instructions]

## **Prerequisites**

* Flutter Version 3.16.9.
* Dart Version 3.2.3.
* Firebase Project set up with Firebase Authentication and Firestore.
* Android Studio for development.


## [Configure Firebase]

     1. Create a Firebase project if you haven’t already.

     2. Add the Firebase configuration files to your project:

     3. For Android, place the google-services.json in the android/app directory.

     4. For iOS, place the GoogleService-Info.plist in the ios/Runner directory.

     5. Enable Firebase Authentication and Firestore in the Firebase console.

     6. Set up Firebase for your Flutter project by following the Firebase setup documentation for Flutter.


## [Configure Drift Local Database]

     1. Setup: Add drift, and path_provider as dependencies in the pubspec.yaml file. Use drift_dev and build_runner for code generation.

     2. Define Tables: Create Dart classes for database tables by extending Table. Specify the columns and their properties, such as data types, constraints, and default values.

     3. Generate Code: Run dart run build_runner build to generate code for managing tables and queries.

     4. Database Initialization: Use a LazyDatabase to create and manage the database file, ensuring it integrates seamlessly with Flutter’s file system.

     5. CRUD Operations: Implement Create, Read, Update, and Delete (CRUD) operations in the database class by extending GeneratedDatabase. Drift provides APIs for both simple and complex queries.


## [Folder Structure]

    lib/
        ├── core/
        ├── data/
        │       ├── models/
        │       ├── repositories/
        ├── domain/
        │       ├──database/
        │       ├──entities/    
        │       ├──preference/    
        │       ├── usecases/
        ├── presentation/
        │       ├── screens/
        │       └── widgets/
        ├── providers/
        ├── main.dart

    1. Core Layer : Contains theme, enum, extension routes, size,color,valaidation and constant  
    
    2. Data Layer : Contains the models, repositories, and logic to interact with both local and remote data sources (Firestore, Drift).

    3. Domain Layer : Conatins use cases, and entities. This layer is independent of external libraries and frameworks.

    4. Presentation Layer : Contains UI-related code, including screens, view models, and widgets.
    
    5. Proivder : Contains business logic

## [App Description]

* This Flutter app is designed to provide seamless task management with Firebase integration and robust offline synchronization. Here’s an overview of its features:

## Key Features:

###   1. Authentication:
         Users can register, log in, and reset their passwords via email. They can also update their email addresses directly within the app.

###   2. Task Management:
         Users can view, create, and update tasks.
         Tasks can only be updated if their status is set to "pending."
         Task statuses can be changed as needed.

###   3. Data Syncing:
         On the initial access to the home screen, the app automatically syncs task data from Firebase to the local Drift database, ensuring all tasks are accessible offline.
         
###   4. Offline Support:
         Users can create, update, and delete tasks even without an internet connection.
         Offline changes are stored in the local database and synchronized with Firebase once the internet connection is restored.

###   5. Background Syncing:
         Using WorkManager, the app schedules background tasks to sync local changes with Firebase when the device reconnects to the internet.

###   6. Real-Time Syncing:
         When a task is added or updated, it is instantly synced with Firebase if an internet connection is available. Otherwise, it is queued for later synchronization.

###   7. Intuitive Swipe Actions:
        Swipe Left to Right: Marks the task as completed.
        Swipe Right to Left: Permanently deletes the task.

## Summary:
    The app offers a powerful and user-friendly experience by combining Firebase authentication, real-time and offline task management, and background synchronization. With intuitive swipe gestures for task updates and deletions, it ensures users can efficiently manage their tasks, whether online or offline.
















