// lib/core/models/assignment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum AssignmentStatus { pending, submitted, late, graded }

class AssignmentModel {
  final String id;
  final String title;
  final String description;
  final String subjectCode;
  final String subject;
  final String teacher;
  final String department;
  final String semester;
  final DateTime deadline;
  final DateTime createdAt;
  final double? totalMarks;
  final AssignmentStatus status;
  final String? submissionNote;
  final double? obtainedMarks;
  final List<String> attachments;

  const AssignmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectCode,
    required this.subject,
    required this.teacher,
    required this.department,
    required this.semester,
    required this.deadline,
    required this.createdAt,
    this.totalMarks,
    required this.status,
    this.submissionNote,
    this.obtainedMarks,
    this.attachments = const [],
  });

  factory AssignmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AssignmentModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      subjectCode: data['subjectCode'] ?? '',
      subject: data['subject'] ?? '',
      teacher: data['teacher'] ?? '',
      department: data['department'] ?? '',
      semester: data['semester'] ?? '',
      deadline: (data['deadline'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      totalMarks: (data['totalMarks'] ?? 0).toDouble(),
      status: AssignmentStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => AssignmentStatus.pending,
      ),
      submissionNote: data['submissionNote'],
      obtainedMarks: data['obtainedMarks']?.toDouble(),
      attachments: List<String>.from(data['attachments'] ?? []),
    );
  }

  bool get isOverdue =>
      deadline.isBefore(DateTime.now()) && status == AssignmentStatus.pending;
  int get daysLeft => deadline.difference(DateTime.now()).inDays;

  static List<AssignmentModel> get dummyList => [
        AssignmentModel(
          id: '1',
          title: 'Software Requirements Specification',
          description:
              'Write a complete SRS document for a University Management System following IEEE standards.',
          subjectCode: 'CSE-501',
          subject: 'Software Engineering',
          teacher: 'Dr. Rahman',
          department: 'CSE',
          semester: '5th',
          deadline: DateTime.now().add(const Duration(days: 3)),
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          totalMarks: 20,
          status: AssignmentStatus.pending,
        ),
        AssignmentModel(
          id: '2',
          title: 'Dijkstra Algorithm Implementation',
          description:
              'Implement Dijkstra\'s shortest path algorithm in Python and analyze its time complexity.',
          subjectCode: 'CSE-502',
          subject: 'Algorithms',
          teacher: 'Dr. Islam',
          department: 'CSE',
          semester: '5th',
          deadline: DateTime.now().add(const Duration(days: 7)),
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          totalMarks: 15,
          status: AssignmentStatus.submitted,
        ),
        AssignmentModel(
          id: '3',
          title: 'Network Topology Design',
          description:
              'Design a complete network topology for a university campus with proper subnetting.',
          subjectCode: 'CSE-503',
          subject: 'Computer Networks',
          teacher: 'Prof. Karim',
          department: 'CSE',
          semester: '5th',
          deadline: DateTime.now().subtract(const Duration(days: 1)),
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          totalMarks: 25,
          status: AssignmentStatus.graded,
          obtainedMarks: 22,
        ),
      ];
}
