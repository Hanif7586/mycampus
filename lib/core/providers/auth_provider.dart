// lib/core/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;
  bool _isLoading = false;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _initAuth();
  }

  void _initAuth() {
    _authService.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser != null) {
        _user = await _authService.getCurrentUserData();
        _status = AuthStatus.authenticated;
      } else {
        _user = null;
        _status = AuthStatus.unauthenticated;
      }
      notifyListeners();
    });
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _errorMessage = null;
      _user = await _authService.signIn(email: email, password: password);
      if (_user != null) {
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
    required String department,
    String? studentId,
    String? batch,
    String? semester,
    String? section,
  }) async {
    try {
      _setLoading(true);
      _errorMessage = null;
      _user = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
        department: department,
        studentId: studentId,
        batch: batch,
        semester: semester,
        section: section,
      );
      if (_user != null) {
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void updateUser(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
