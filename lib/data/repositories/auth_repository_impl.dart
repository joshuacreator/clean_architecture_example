import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) async {
    final userModel = await authDataSource.signInWithEmailAndPassword(email, password);
    return userModel;
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(String email, String password, String name) async {
    final userModel = await authDataSource.signUpWithEmailAndPassword(email, password, name);
    return userModel;
  }

  @override
  Future<void> signOut() async {
    await authDataSource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await authDataSource.getCurrentUser();
    return userModel;
  }

  @override
  Future<void> updateUserProfile(UserEntity user) async {
    final userModel = UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      profileImageUrl: user.profileImageUrl,
    );
    await authDataSource.updateUserProfile(userModel);
  }
}