// lib/core/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../consts/app_constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign In
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (credential.user != null) {
        return await _getUserData(credential.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register
  Future<UserModel?> register({
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
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (credential.user != null) {
        final user = UserModel(
          uid: credential.user!.uid,
          name: name.trim(),
          email: email.trim(),
          phone: phone.trim(),
          role: role,
          department: department,
          studentId: studentId,
          batch: batch,
          semester: semester,
          section: section,
          createdAt: DateTime.now(),
        );
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(credential.user!.uid)
            .set(user.toMap());
        await credential.user!.updateDisplayName(name.trim());
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get User Data
  Future<UserModel?> _getUserData(String uid) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    if (currentUser == null) return null;
    return await _getUserData(currentUser!.uid);
  }

  // Update Profile
  Future<void> updateProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .update(data);
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}
