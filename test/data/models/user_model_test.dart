import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture_example/data/models/user_model.dart';
import 'package:clean_architecture_example/domain/entities/user_entity.dart';

void main() {
  group('UserModel', () {
    test('should create a UserModel with required properties', () {
      // Arrange & Act
      final userModel = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        profileImageUrl: 'https://example.com/avatar.jpg',
      );

      // Assert
      expect(userModel.id, '1');
      expect(userModel.email, 'test@example.com');
      expect(userModel.name, 'Test User');
      expect(userModel.profileImageUrl, 'https://example.com/avatar.jpg');
    });

    test('should create a UserModel without optional profileImageUrl', () {
      // Arrange & Act
      final userModel = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      // Assert
      expect(userModel.id, '1');
      expect(userModel.email, 'test@example.com');
      expect(userModel.name, 'Test User');
      expect(userModel.profileImageUrl, isNull);
    });

    test('should create from JSON with all properties', () {
      // Arrange
      final json = {
        'id': '1',
        'email': 'test@example.com',
        'name': 'Test User',
        'profileImageUrl': 'https://example.com/avatar.jpg',
      };

      // Act
      final userModel = UserModel.fromJson(json);

      // Assert
      expect(userModel.id, '1');
      expect(userModel.email, 'test@example.com');
      expect(userModel.name, 'Test User');
      expect(userModel.profileImageUrl, 'https://example.com/avatar.jpg');
    });

    test('should create from JSON without optional profileImageUrl', () {
      // Arrange
      final json = {
        'id': '1',
        'email': 'test@example.com',
        'name': 'Test User',
      };

      // Act
      final userModel = UserModel.fromJson(json);

      // Assert
      expect(userModel.id, '1');
      expect(userModel.email, 'test@example.com');
      expect(userModel.name, 'Test User');
      expect(userModel.profileImageUrl, isNull);
    });

    test('should convert to JSON with all properties', () {
      // Arrange
      final userModel = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        profileImageUrl: 'https://example.com/avatar.jpg',
      );

      // Act
      final json = userModel.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
      expect(json['profileImageUrl'], 'https://example.com/avatar.jpg');
    });

    test('should convert to JSON without optional profileImageUrl', () {
      // Arrange
      final userModel = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      // Act
      final json = userModel.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
      expect(json['profileImageUrl'], isNull);
    });

    test('should convert from UserEntity to UserModel', () {
      // Arrange
      final userEntity = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        profileImageUrl: 'https://example.com/avatar.jpg',
      );

      // Act
      final userModel = UserModel.fromEntity(userEntity);

      // Assert
      expect(userModel.id, userEntity.id);
      expect(userModel.email, userEntity.email);
      expect(userModel.name, userEntity.name);
      expect(userModel.profileImageUrl, userEntity.profileImageUrl);
    });

    test('should be equal when properties are the same', () {
      // Arrange
      final userModel1 = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      final userModel2 = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      // Assert
      expect(userModel1, equals(userModel2));
      expect(userModel1.hashCode, equals(userModel2.hashCode));
    });

    test('should not be equal when properties are different', () {
      // Arrange
      final userModel1 = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      final userModel2 = UserModel(
        id: '2',
        email: 'different@example.com',
        name: 'Different User',
      );

      // Assert
      expect(userModel1, isNot(equals(userModel2)));
      expect(userModel1.hashCode, isNot(equals(userModel2.hashCode)));
    });
  });
}