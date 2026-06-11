import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture_example/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    test('should create a user with required properties', () {
      // Arrange & Act
      final user = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        profileImageUrl: 'https://example.com/avatar.jpg',
      );

      // Assert
      expect(user.id, '1');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.profileImageUrl, 'https://example.com/avatar.jpg');
    });

    test('should create a user without optional profileImageUrl', () {
      // Arrange & Act
      final user = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      // Assert
      expect(user.id, '1');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.profileImageUrl, isNull);
    });

    test('should be equal when properties are the same', () {
      // Arrange
      final user1 = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      final user2 = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      // Assert
      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
    });

    test('should not be equal when properties are different', () {
      // Arrange
      final user1 = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      final user2 = UserEntity(
        id: '2',
        email: 'different@example.com',
        name: 'Different User',
      );

      // Assert
      expect(user1, isNot(equals(user2)));
      expect(user1.hashCode, isNot(equals(user2.hashCode)));
    });

    test('should have correct string representation', () {
      // Arrange
      final user = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        profileImageUrl: 'https://example.com/avatar.jpg',
      );

      // Assert
      expect(user.toString(), contains('UserEntity'));
      expect(user.toString(), contains('id: 1'));
      expect(user.toString(), contains('email: test@example.com'));
      expect(user.toString(), contains('name: Test User'));
      expect(user.toString(), contains('profileImageUrl: https://example.com/avatar.jpg'));
    });
  });
}