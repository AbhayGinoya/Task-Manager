## [Features]

* Authentication & Authorization: Firebase Authentication for user registration, login, forgot passsword and logout.
* Firestore Integration: Store and retrieve a list of items (tasks/notes) from Firestore.
* Offline Caching: Use Drift for local caching and offline access.
* Data Syncing: Sync changes between Firestore and the local database.
* CRUD Operations: Add, delete, update,and display tasks/notes.
* Navigation: Use go_router for navigation between screens.
* User: Change user email and logout.

## [Technologies & Packages Used]

    [Dependencies]

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

[Dev Dependencies]

* drift_dev : drift Database Support
* build_runner : generate default code
* sqlite3_flutter_libs : Local database native file setup.
* mockito : test case.

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

    1. This Flutter app enables users to manage their tasks with Firebase authentication and offline synchronization. The key features of the app are as follows:

    2. Authentication: Users can register using their email and password, log in with the same credentials, and reset their password via email. They can also update their email within the app.

    3. Task Management: Once logged in, users can view, create, and update tasks. A task can only be updated if its status is "pending." Users can also change the task's status.

    4. Syncing Data: On first access to the home screen, the app syncs data from the Firebase server to the local database, ensuring that the user's task data is available offline.

    5. Offline Support: If the device is offline, tasks can still be created, updated, and deleted. These changes are saved in the local database (Isar or Drift). Once the internet connection is restored, the app automatically syncs the local changes with Firebase using WorkManager to schedule background tasks for synchronization.

    6. Task Synchronization: Whenever the user adds or updates a task, it is immediately synced with Firebase when the internet is available. If there’s no internet connection, the task is scheduled for later synchronization once the internet is restored.

    7. This architecture ensures a smooth user experience with robust task management, real-time syncing, and offline capabilities, allowing users to interact with their tasks seamlessly regardless of their network connection.










