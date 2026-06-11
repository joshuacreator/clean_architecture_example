import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture_example/features/authentication/presentation/providers/auth_provider.dart';
import 'package:clean_architecture_example/domain/entities/user_entity.dart';
import 'package:clean_architecture_example/domain/usecases/sign_in_usecase.dart';
import 'package:clean_architecture_example/domain/usecases/sign_up_usecase.dart';
import '../../../../mocks/mock_auth_repository.dart';

void main() {
  group('AuthProvider', () {
    late MockAuthRepository mockAuthRepository;
    late SignInUseCase signInUseCase;
    late SignUpUseCase signUpUseCase;
    late AuthProvider authProvider;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      signInUseCase = SignInUseCase(authRepository: mockAuthRepository);
      signUpUseCase = SignUpUseCase(authRepository: mockAuthRepository);
      authProvider = AuthProvider(
        signInUseCase: signInUseCase,
        signUpUseCase: signUpUseCase,
      );
    });

    test('should initialize with no user and not loading', () {
      // Assert
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isLoading, false);
      expect(authProvider.error, isNull);
    });

    test('should sign in successfully and update state', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final expectedUser = UserEntity(id: '1', email: email, name: 'Test User');
      mockAuthRepository.mockUser = expectedUser;

      // Act
      await authProvider.signIn(email, password);

      // Assert
      expect(authProvider.currentUser, equals(expectedUser));
      expect(authProvider.isLoading, false);
      expect(authProvider.error, isNull);
    });

    test('should set loading state during sign in', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final expectedUser = UserEntity(id: '1', email: email, name: 'Test User');
      mockAuthRepository.mockUser = expectedUser;

      // Track state changes
      var loadingStates = <bool>[];
      void listener() {
        loadingStates.add(authProvider.isLoading);
      }

      authProvider.addListener(listener);

      // Act
      await authProvider.signIn(email, password);

      // Remove listener to prevent further updates
      authProvider.removeListener(listener);

      // Assert - Should go from true -> false (loading starts immediately)
      expect(loadingStates.length, greaterThanOrEqualTo(2));
      expect(loadingStates.first, true); // Loading state starts immediately
      expect(loadingStates.last, false); // Final state
    });

    test('should handle sign in errors and update error state', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final exception = Exception('Authentication failed');
      mockAuthRepository.mockException = exception;

      // Act
      await authProvider.signIn(email, password);

      // Assert
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isLoading, false);
      expect(authProvider.error, equals(exception.toString()));
    });

    test('should sign up successfully and update state', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const name = 'Test User';
      final expectedUser = UserEntity(id: '1', email: email, name: name);
      mockAuthRepository.mockUser = expectedUser;

      // Act
      await authProvider.signUp(email, password, name);

      // Assert
      expect(authProvider.currentUser, equals(expectedUser));
      expect(authProvider.isLoading, false);
      expect(authProvider.error, isNull);
    });

    test('should handle sign up errors and update error state', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const name = 'Test User';
      final exception = Exception('Registration failed');
      mockAuthRepository.mockException = exception;

      // Act
      await authProvider.signUp(email, password, name);

      // Assert
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isLoading, false);
      expect(authProvider.error, equals(exception.toString()));
    });

    test('should clear error on successful operation', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final exception = Exception('Authentication failed');
      mockAuthRepository.mockException = exception;

      // Set an error first
      await authProvider.signIn(email, password);
      expect(authProvider.error, isNotNull);

      // Clear exception for successful operation
      mockAuthRepository.mockException = null;
      final expectedUser = UserEntity(id: '1', email: email, name: 'Test User');
      mockAuthRepository.mockUser = expectedUser;

      // Act - Perform a successful operation
      await authProvider.signIn(email, password);

      // Assert - Error should be cleared
      expect(authProvider.error, isNull);
    });

    test('should sign out successfully and clear user', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final expectedUser = UserEntity(id: '1', email: email, name: 'Test User');
      mockAuthRepository.mockUser = expectedUser;

      // Sign in first to set a user
      await authProvider.signIn(email, password);
      expect(authProvider.currentUser, isNotNull);

      // Act
      authProvider.signOut();

      // Assert
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isLoading, false);
      expect(authProvider.error, isNull);
    });

    test('should sign out successfully even if repository fails', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final expectedUser = UserEntity(id: '1', email: email, name: 'Test User');
      mockAuthRepository.mockUser = expectedUser;

      // Sign in first to set a user
      await authProvider.signIn(email, password);

      // Set exception for sign out (but signOut is synchronous so it won't affect)
      final exception = Exception('Sign out failed');
      mockAuthRepository.mockException = exception;

      // Act
      authProvider.signOut();

      // Assert - User should be cleared regardless of repository errors
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isLoading, false);
      expect(authProvider.error, isNull); // signOut doesn't set errors
    });

    test('should notify listeners when state changes', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final expectedUser = UserEntity(id: '1', email: email, name: 'Test User');
      mockAuthRepository.mockUser = expectedUser;

      var notifyCount = 0;
      authProvider.addListener(() {
        notifyCount++;
      });

      // Act
      await authProvider.signIn(email, password);

      // Assert - Should notify at least 2 times (loading start and loading end)
      expect(notifyCount, greaterThanOrEqualTo(2));
    });

    test('should handle multiple rapid sign in attempts', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final expectedUser = UserEntity(id: '1', email: email, name: 'Test User');
      mockAuthRepository.mockUser = expectedUser;

      // Act - Multiple rapid calls
      await Future.wait([
        authProvider.signIn(email, password),
        authProvider.signIn(email, password),
        authProvider.signIn(email, password),
      ]);

      // Assert - All should complete successfully
      expect(authProvider.currentUser, equals(expectedUser));
      expect(authProvider.isLoading, false);
      expect(authProvider.error, isNull);
    });
  });
}
