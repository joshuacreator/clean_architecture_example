import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture_example/domain/entities/user_entity.dart';
import 'package:clean_architecture_example/domain/usecases/sign_up_usecase.dart';
import '../../mocks/mock_auth_repository.dart';

void main() {
  group('SignUpUseCase', () {
    late MockAuthRepository mockAuthRepository;
    late SignUpUseCase signUpUseCase;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      signUpUseCase = SignUpUseCase(authRepository: mockAuthRepository);
    });

    test('should sign up successfully with valid credentials', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const name = 'Test User';
      final expectedUser = UserEntity(id: '1', email: email, name: name);
      
      mockAuthRepository.mockUser = expectedUser;

      // Act
      final result = await signUpUseCase.execute(email, password, name);

      // Assert
      expect(result, equals(expectedUser));
    });

    test('should throw exception when email is empty', () async {
      // Arrange
      const emptyEmail = '';
      const password = 'password123';
      const name = 'Test User';

      // Act & Assert
      expect(() => signUpUseCase.execute(emptyEmail, password, name),
          throwsA(isA<Exception>()));
    });

    test('should throw exception when password is empty', () async {
      // Arrange
      const email = 'test@example.com';
      const emptyPassword = '';
      const name = 'Test User';

      // Act & Assert
      expect(() => signUpUseCase.execute(email, emptyPassword, name),
          throwsA(isA<Exception>()));
    });

    test('should throw exception when name is empty', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const emptyName = '';

      // Act & Assert
      expect(() => signUpUseCase.execute(email, password, emptyName),
          throwsA(isA<Exception>()));
    });

    test('should throw exception when password is too short', () async {
      // Arrange
      const email = 'test@example.com';
      const shortPassword = '12345'; // 5 characters
      const name = 'Test User';

      // Act & Assert
      expect(() => signUpUseCase.execute(email, shortPassword, name),
          throwsA(isA<Exception>()));
    });

    test('should throw exception when email format is invalid', () async {
      // Arrange
      const invalidEmail = 'invalid-email';
      const password = 'password123';
      const name = 'Test User';

      // Act & Assert
      expect(() => signUpUseCase.execute(invalidEmail, password, name),
          throwsA(isA<Exception>()));
    });

    test('should propagate repository exceptions', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const name = 'Test User';
      final exception = Exception('Registration failed');
      
      mockAuthRepository.mockException = exception;

      // Act & Assert
      expect(() => signUpUseCase.execute(email, password, name),
          throwsA(equals(exception)));
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
      const name = 'Test User';
      final expectedUser = UserEntity(id: '1', email: 'test@example.com', name: name);
      
      mockAuthRepository.mockUser = expectedUser;

      // Act & Assert - All should not throw
      for (final email in validEmails) {
        expect(() => signUpUseCase.execute(email, password, name), returnsNormally);
      }
    });

    test('should accept passwords with 6 or more characters', () async {
      // Arrange
      const email = 'test@example.com';
      const validPasswords = [
        '123456',      // exactly 6 characters
        'password',    // 8 characters
        'verylongpassword123', // 19 characters
      ];
      const name = 'Test User';
      final expectedUser = UserEntity(id: '1', email: email, name: name);
      
      mockAuthRepository.mockUser = expectedUser;

      // Act & Assert - All should not throw
      for (final password in validPasswords) {
        expect(() => signUpUseCase.execute(email, password, name), returnsNormally);
      }
    });
  });
}