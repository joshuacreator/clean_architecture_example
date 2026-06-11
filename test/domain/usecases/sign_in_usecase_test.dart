import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture_example/domain/entities/user_entity.dart';
import 'package:clean_architecture_example/domain/usecases/sign_in_usecase.dart';
import '../../mocks/mock_auth_repository.dart';

void main() {
  group('SignInUseCase', () {
    late MockAuthRepository mockAuthRepository;
    late SignInUseCase signInUseCase;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      signInUseCase = SignInUseCase(authRepository: mockAuthRepository);
    });

    test('should sign in successfully with valid credentials', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final expectedUser = UserEntity(id: '1', email: email, name: 'Test User');

      mockAuthRepository.mockUser = expectedUser;

      // Act
      final result = await signInUseCase.execute(email, password);

      // Assert
      expect(result, equals(expectedUser));
    });

    test('should throw exception when email is empty', () async {
      // Arrange
      const emptyEmail = '';
      const password = 'password123';

      // Act & Assert
      expect(
        () => signInUseCase.execute(emptyEmail, password),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when password is empty', () async {
      // Arrange
      const email = 'test@example.com';
      const emptyPassword = '';

      // Act & Assert
      expect(
        () => signInUseCase.execute(email, emptyPassword),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when email format is invalid', () async {
      // Arrange
      const invalidEmail = 'invalid-email';
      const password = 'password123';

      // Act & Assert
      expect(
        () => signInUseCase.execute(invalidEmail, password),
        throwsA(isA<Exception>()),
      );
    });

    test('should propagate repository exceptions', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final exception = Exception('Authentication failed');

      mockAuthRepository.mockException = exception;

      // Act & Assert
      expect(
        () => signInUseCase.execute(email, password),
        throwsA(equals(exception)),
      );
    });

    test('should accept valid email formats', () async {
      // Arrange
      const validEmails = [
        'test@example.com',
        'user.name@example.co.uk',
        'user+tag@example.org',
        'user@subdomain.example.com',
      ];
      const password = 'password123';
      final expectedUser = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      mockAuthRepository.mockUser = expectedUser;

      // Act & Assert - All should not throw
      for (final email in validEmails) {
        expect(() => signInUseCase.execute(email, password), returnsNormally);
      }
    });
  });
}
