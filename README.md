# Clean Architecture Flutter Example

A comprehensive Flutter application demonstrating Clean Architecture principles with feature-first organization, following best practices for scalable and maintainable mobile app development.

## 🏗️ Architecture Overview

This project implements Clean Architecture with a clear separation of concerns across four main layers:

### Architecture Flow
```
UI → Provider → Use Case → Repository Contract ← Repository Implementation ← API/DB
```

### Layer Responsibilities

1. **Presentation Layer** (`lib/features/`) - UI and State Management
2. **Domain Layer** (`lib/domain/`) - Business Logic and Entities
3. **Data Layer** (`lib/data/`) - Data Sources and Implementation
4. **Core Layer** (`lib/core/`) - Shared Utilities and Configuration

## 📁 Project Structure

```
lib/
├── core/                 # Shared utilities and configuration
│   ├── constants/        # Application constants
│   ├── utils/           # Helper functions and utilities
│   ├── theme/           # App theme and styling
│   └── config/          # App configuration
│
├── data/                 # Data layer implementation
│   ├── datasources/     # Abstract data sources (API, DB)
│   ├── repositories/    # Concrete repository implementations
│   └── models/          # Data Transfer Objects (DTOs)
│
├── domain/               # Business logic layer
│   ├── entities/        # Business objects (pure data structures)
│   ├── repositories/    # Abstract repository contracts
│   └── usecases/        # Business use cases/interactors
│
├── features/             # Feature-based organization
│   └── authentication/  # Example feature: Authentication
│       └── presentation/
│           ├── providers/   # State management (ChangeNotifier)
│           ├── screens/     # Full page components
│           └── widgets/     # Reusable UI components
│
└── main.dart            # Application entry point
```

## 🎯 Key Principles

### 1. Dependency Rule
- **Inner layers know nothing about outer layers**
- **Dependencies point inward** (Domain → Core, Data → Domain, Presentation → Domain)
- **No circular dependencies** between layers

### 2. Separation of Concerns
- **Entities**: Pure business objects, no framework dependencies
- **Use Cases**: Single business operations with validation
- **Repositories**: Data access contracts
- **Data Sources**: Concrete data implementations
- **UI Components**: Presentation-only, no business logic

### 3. Testability
- Each layer can be tested independently
- Mock implementations for all dependencies
- Business logic isolated from framework concerns

## 🧩 Layer Implementation Details

### Domain Layer (`lib/domain/`)

**Entities** - Pure business objects:
```dart
class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  
  // Business logic methods only
}
```

**Repositories** - Abstract contracts:
```dart
abstract class AuthRepository {
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> signUpWithEmailAndPassword(String email, String password, String name);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
}
```

**Use Cases** - Business operations:
```dart
class SignInUseCase {
  final AuthRepository authRepository;
  
  Future<UserEntity> execute(String email, String password) async {
    // Validation logic
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }
    
    // Business rules
    return await authRepository.signInWithEmailAndPassword(email, password);
  }
}
```

### Data Layer (`lib/data/`)

**Models** - Data Transfer Objects:
```dart
class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.profileImageUrl,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
    };
  }
}
```

**Repository Implementations** - Concrete implementations:
```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;
  
  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) async {
    final userModel = await authDataSource.signInWithEmailAndPassword(email, password);
    return userModel; // Implicit conversion from Model to Entity
  }
}
```

### Presentation Layer (`lib/features/`)

**Providers** - State management:
```dart
class AuthProvider with ChangeNotifier {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  
  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  // Business logic through use cases only
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _currentUser = await signInUseCase.execute(email, password);
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

**Screens** - UI components:
```dart
class LoginScreen extends StatefulWidget {
  final AuthProvider authProvider;
  
  const LoginScreen({super.key, required this.authProvider});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // UI only, no business logic
          if (authProvider.isLoading) return const CircularProgressIndicator();
          if (authProvider.error != null) Text(authProvider.error!);
          
          return Column(
            children: [
              TextField(controller: _emailController),
              TextField(controller: _passwordController),
              ElevatedButton(
                onPressed: () => authProvider.signIn(_emailController.text, _passwordController.text),
                child: const Text('Sign In'),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.1 or higher
- Dart 3.0 or higher

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

### Running Tests
```bash
flutter test
```

### Building for Production
```bash
flutter build apk --release  # For Android
flutter build ios --release   # For iOS
```

## 🧪 Testing Strategy

### Unit Testing Layers
- **Domain Layer**: Test use cases with manual mock repositories
- **Data Layer**: Test repository implementations with manual mock data sources  
- **Presentation Layer**: Test providers with mock use cases

### Manual Mock Implementation
This project uses manual mocks (no external mocking libraries) for better control and simplicity:

**Mock Repository Example**:
```dart
class MockAuthRepository implements AuthRepository {
  UserEntity? mockUser;
  Exception? mockException;

  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) async {
    if (mockException != null) throw mockException!;
    return mockUser ?? UserEntity(id: '1', email: email, name: 'Test User');
  }
}
```

**Mock Data Source Example**:
```dart
class TestAuthDataSource implements AuthDataSource {
  UserModel? mockUser;
  Exception? mockException;

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    if (mockException != null) throw mockException!;
    return mockUser ?? UserModel(id: '1', email: email, name: 'Test User');
  }
}
```

### Example Test Structure
```dart
test('SignInUseCase should validate email format', () async {
  // Arrange
  final mockAuthRepository = MockAuthRepository();
  final useCase = SignInUseCase(authRepository: mockAuthRepository);
  
  // Act & Assert
  expect(() => useCase.execute('invalid-email', 'password'),
         throwsA(isA<Exception>()));
});
```

### Test Directory Structure
The test directory mirrors the lib structure for maintainability:

```
test/
├── data/
│   ├── models/
│   │   └── user_model_test.dart
│   └── repositories/
│       └── auth_repository_impl_test.dart
├── domain/
│   ├── entities/
│   │   └── user_entity_test.dart
│   └── usecases/
│       ├── sign_in_usecase_test.dart
│       └── sign_up_usecase_test.dart
├── features/
│   └── authentication/
│       └── presentation/
│           └── providers/
│               └── auth_provider_test.dart
└── mocks/
    └── mock_auth_repository.dart
```

## 🔧 Dependency Management

### Dependency Injection
Dependencies are injected through constructors:
```dart
// Use case depends on abstract repository
SignInUseCase({required this.authRepository});

// Repository implementation depends on abstract data source
AuthRepositoryImpl({required this.authDataSource});

// Provider depends on use cases
AuthProvider({required this.signInUseCase, required this.signUpUseCase});
```

### Recommended DI Solutions
- **Riverpod** for state management and dependency injection

## 📈 Scalability Patterns

### Adding New Features
1. Create feature folder in `lib/features/`
2. Implement domain layer contracts
3. Create data layer implementations
4. Build presentation components
5. Connect through dependency injection

### Extending Existing Features
1. Add new methods to repository contracts
2. Implement in repository implementations
3. Create new use cases if needed
4. Update providers and UI components

## 🛡️ Best Practices

### Code Organization
- **One class per file** (except for very small related classes)
- **Feature-based grouping** over technical-layer grouping
- **Clear naming conventions** (Entity, Model, Repository, UseCase, Provider)

### Error Handling
- **Domain layer**: Business exceptions with clear messages
- **Data layer**: Technical exceptions with proper logging
- **Presentation layer**: User-friendly error messages

### State Management
- **Business state** in providers using use cases
- **UI state** in widget state classes
- **Global state** in dedicated providers

## 🤝 Contributing

When contributing to this architecture:
1. Follow the dependency rules strictly
2. Maintain separation of concerns
3. Write tests for new functionality
4. Use the existing patterns and conventions

## 📚 Learning Resources

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture Guide](https://resocoder.com/flutter-clean-architecture-tutorial)
- [Domain-Driven Design](https://domainlanguage.com/ddd/)

## 🎯 Benefits of This Architecture

- **Testability**: Each layer can be tested in isolation
- **Maintainability**: Clear boundaries reduce complexity
- **Scalability**: Easy to add new features without breaking existing code
- **Team Collaboration**: Different teams can work on different layers
- **Technology Independence**: Business logic is framework-agnostic

## 📊 Performance Considerations

- Use **async/await** properly for non-blocking operations
- Implement **caching strategies** at the data layer
- Consider **state persistence** for better UX
- Optimize **widget rebuilds** with proper state management

---

Built with ❤️ using Clean Architecture principles for scalable Flutter development.