import 'package:omari_bank_app/features/auth/domain/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> signIn(String email, String password);
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  });
  Future<void> signOut();
  Future<UserModel?> getCurrentUser(String userId);
  Stream<UserModel?> get authStateChanges;
}
