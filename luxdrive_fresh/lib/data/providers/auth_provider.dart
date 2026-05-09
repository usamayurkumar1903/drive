// lib/data/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { unauthenticated, authenticated }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final bool isGoogleUser;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.isGoogleUser = false,
  });
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: UserModel(
          id: userId,
          name: prefs.getString('user_name') ?? 'User',
          email: prefs.getString('user_email') ?? '',
          photoUrl: prefs.getString('user_photo'),
          isGoogleUser: prefs.getBool('user_is_google') ?? false,
        ),
      );
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock validation - replace with Firebase Auth
    if (email.isNotEmpty && password.length >= 6) {
      await _saveSession(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first,
        email: email,
        isGoogle: false,
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        isLoading: false,
        user: UserModel(
          id: 'user_001',
          name: email.split('@').first,
          email: email,
        ),
      );
      return true;
    }

    state = state.copyWith(
      isLoading: false,
      error: 'Invalid email or password',
    );
    return false;
  }

  Future<bool> signUpWithEmail(
      String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 1000));

    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      await _saveSession(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        isGoogle: false,
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        isLoading: false,
        user: UserModel(id: 'user_new', name: name, email: email),
      );
      return true;
    }

    state = state.copyWith(
      isLoading: false,
      error: 'Please fill all fields correctly',
    );
    return false;
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock Google sign-in - replace with actual google_sign_in + Firebase
    // final googleUser = await GoogleSignIn().signIn();
    // final googleAuth = await googleUser?.authentication;
    // final credential = GoogleAuthProvider.credential(...)
    // await FirebaseAuth.instance.signInWithCredential(credential);

    await _saveSession(
      id: 'google_user_001',
      name: 'Alex Mercer',
      email: 'alex.mercer@gmail.com',
      isGoogle: true,
    );
    state = state.copyWith(
      status: AuthStatus.authenticated,
      isLoading: false,
      user: const UserModel(
        id: 'google_user_001',
        name: 'Alex Mercer',
        email: 'alex.mercer@gmail.com',
        isGoogleUser: true,
      ),
    );
    return true;
  }

  Future<bool> signInWithBiometric() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // local_auth integration:
      // final auth = LocalAuthentication();
      // final didAuth = await auth.authenticate(
      //   localizedReason: 'Sign in to LuxDrive',
      //   options: const AuthenticationOptions(biometricOnly: true),
      // );
      // if (didAuth) { ... restore session }

      await Future.delayed(const Duration(milliseconds: 800));
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      if (userId != null) {
        await _checkSession();
        state = state.copyWith(isLoading: false);
        return true;
      }
      state = state.copyWith(
          isLoading: false, error: 'No saved session for biometric login');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Biometric failed');
      return false;
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = const AuthState();
  }

  Future<void> _saveSession({
    required String id,
    required String name,
    required String email,
    required bool isGoogle,
    String? photo,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', id);
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setBool('user_is_google', isGoogle);
    if (photo != null) await prefs.setString('user_photo', photo);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((_) => AuthNotifier());
