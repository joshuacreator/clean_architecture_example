import 'package:flutter/foundation.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/usecases/sign_in_usecase.dart';
import '../../../../domain/usecases/sign_up_usecase.dart';

class AuthProvider with ChangeNotifier {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;

  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider({required this.signInUseCase, required this.signUpUseCase});

  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
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

  Future<void> signUp(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await signUpUseCase.execute(email, password, name);
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void signOut() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }
}
