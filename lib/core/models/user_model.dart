// lib/core/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String department;
  final String? studentId;
  final String? batch;
  final String? semester;
  final String? section;
  final String? avatarUrl;
  final DateTime? createdAt;
  final bool isActive;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    this.studentId,
    this.batch,
    this.semester,
    this.section,
    this.avatarUrl,
    this.createdAt,
    this.isActive = true,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'student',
      department: data['department'] ?? '',
      studentId: data['studentId'],
      batch: data['batch'],
      semester: data['semester'],
      section: data['section'],
      avatarUrl: data['avatarUrl'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'department': department,
      'studentId': studentId,
      'batch': batch,
      'semester': semester,
      'section': section,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'isActive': isActive,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? department,
    String? semester,
    String? section,
    String? avatarUrl,
    bool? isActive,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      role: role,
      department: department ?? this.department,
      studentId: studentId,
      batch: batch,
      semester: semester ?? this.semester,
      section: section ?? this.section,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  bool get isStudent => role == 'student';
  bool get isTeacher => role == 'teacher';
  bool get isAdmin => role == 'admin';
}
