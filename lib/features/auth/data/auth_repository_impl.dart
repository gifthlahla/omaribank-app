import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:omari_bank_app/features/auth/domain/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;
  
  AuthRepositoryImpl({required SupabaseClient supabase}) : _supabase = supabase;

  @override
  Future<UserModel?> signIn(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user != null) {
      return await getCurrentUser(response.user!.id);
    }
    return null;
  }

  @override
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    if (response.user != null) {
      await _supabase.from('profiles').update({
        'phone_number': phoneNumber,
      }).eq('id', response.user!.id);
      return await getCurrentUser(response.user!.id);
    }
    return null;
  }

  @override
  Future<void> signOut() async => await _supabase.auth.signOut();

  @override
  Future<UserModel?> getCurrentUser(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    final user = _supabase.auth.currentUser;
    return UserModel(
      id: response['id'],
      email: user?.email ?? '',
      fullName: response['full_name'] ?? '',
      phoneNumber: response['phone_number'],
      avatarUrl: response['avatar_url'],
      createdAt: DateTime.parse(response['created_at']),
    );
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((event) async {
      final user = event.session?.user;
      if (user != null) return await getCurrentUser(user.id);
      return null;
    }).asyncMap((user) => user);
  }
}
