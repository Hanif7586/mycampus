// lib/core/models/notice_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum NoticePriority { low, medium, high, urgent }

class NoticeModel {
  final String id;
  final String title;
  final String body;
  final String postedBy;
  final String department;
  final NoticePriority priority;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final List<String> attachments;
  final bool isPinned;
  final String category;

  const NoticeModel({
    required this.id,
    required this.title,
    required this.body,
    required this.postedBy,
    required this.department,
    required this.priority,
    required this.createdAt,
    this.expiresAt,
    this.attachments = const [],
    this.isPinned = false,
    required this.category,
  });

  factory NoticeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoticeModel(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      postedBy: data['postedBy'] ?? '',
      department: data['department'] ?? 'All',
      priority: NoticePriority.values.firstWhere(
        (e) => e.name == data['priority'],
        orElse: () => NoticePriority.medium,
      ),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      expiresAt: data['expiresAt'] != null
          ? (data['expiresAt'] as Timestamp).toDate()
          : null,
      attachments: List<String>.from(data['attachments'] ?? []),
      isPinned: data['isPinned'] ?? false,
      category: data['category'] ?? 'General',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'postedBy': postedBy,
      'department': department,
      'priority': priority.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'attachments': attachments,
      'isPinned': isPinned,
      'category': category,
    };
  }

  // Dummy data for testing
  static List<NoticeModel> get dummyList => [
        NoticeModel(
          id: '1',
          title: 'Mid-Term Exam Schedule Released',
          body:
              'The mid-term examination schedule for the Fall 2026 semester has been released. Students must check their department notice board for details.',
          postedBy: 'Academic Affairs',
          department: 'All',
          priority: NoticePriority.urgent,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          category: 'Exam',
          isPinned: true,
        ),
        NoticeModel(
          id: '2',
          title: 'Library New Books Available',
          body:
              'The central library has received new books for CSE, EEE, and Business departments. Students can borrow from today.',
          postedBy: 'Library',
          department: 'All',
          priority: NoticePriority.low,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          category: 'Library',
          isPinned: false,
        ),
        NoticeModel(
          id: '3',
          title: 'Annual Sports Day Registration',
          body:
              'Registration for Annual Sports Day 2026 is now open. Students interested in participating should register with their department coordinator.',
          postedBy: 'Student Affairs',
          department: 'All',
          priority: NoticePriority.medium,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          category: 'Event',
          isPinned: false,
        ),
        NoticeModel(
          id: '4',
          title: 'Scholarship Application Deadline',
          body:
              'Merit and Need-based scholarship applications for 2026-27 must be submitted by October 15, 2026.',
          postedBy: 'Finance Office',
          department: 'All',
          priority: NoticePriority.high,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          category: 'Finance',
          isPinned: false,
        ),
        NoticeModel(
          id: '5',
          title: 'Wi-Fi Network Upgrade',
          body:
              'Campus Wi-Fi will be undergoing maintenance on Saturday 6 AM - 12 PM. Temporary outage expected.',
          postedBy: 'IT Department',
          department: 'All',
          priority: NoticePriority.medium,
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
          category: 'IT',
          isPinned: false,
        ),
      ];
}
