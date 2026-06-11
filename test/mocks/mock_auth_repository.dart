import 'package:clean_architecture_example/domain/entities/user_entity.dart';
import 'package:clean_architecture_example/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  UserEntity? mockUser;
  Exception? mockException;

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (mockException != null) throw mockException!;
    return mockUser ?? UserEntity(id: '1', email: email, name: 'Test User');
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    if (mockException != null) throw mockException!;
    return mockUser ?? UserEntity(id: '1', email: email, name: name);
  }

  @override
  Future<void> signOut() async {
    if (mockException != null) throw mockException!;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    if (mockException != null) throw mockException!;
    return mockUser;
  }

  @override
  Future<void> updateUserProfile(UserEntity user) async {
    if (mockException != null) throw mockException!;
    mockUser = user;
  }
}
