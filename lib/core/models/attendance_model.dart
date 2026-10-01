// lib/core/models/attendance_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum AttendanceStatus { present, absent, late, excused }

class AttendanceRecord {
  final String id;
  final String studentId;
  final String subjectCode;
  final String subject;
  final AttendanceStatus status;
  final DateTime date;
  final String? note;

  const AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.subjectCode,
    required this.subject,
    required this.status,
    required this.date,
    this.note,
  });

  factory AttendanceRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AttendanceRecord(
      id: doc.id,
      studentId: data['studentId'] ?? '',
      subjectCode: data['subjectCode'] ?? '',
      subject: data['subject'] ?? '',
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => AttendanceStatus.present,
      ),
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
      note: data['note'],
    );
  }
}

class SubjectAttendance {
  final String subjectCode;
  final String subject;
  final String teacher;
  final int totalClasses;
  final int presentCount;
  final int absentCount;
  final int lateCount;

  const SubjectAttendance({
    required this.subjectCode,
    required this.subject,
    required this.teacher,
    required this.totalClasses,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
  });

  double get percentage =>
      totalClasses > 0 ? (presentCount / totalClasses) * 100 : 0;

  bool get isCritical => percentage < 75;
  bool get isWarning => percentage >= 75 && percentage < 80;

  // Dummy list
  static List<SubjectAttendance> get dummyList => [
        const SubjectAttendance(
          subjectCode: 'CSE-501',
          subject: 'Software Engineering',
          teacher: 'Dr. Rahman',
          totalClasses: 30,
          presentCount: 27,
          absentCount: 2,
          lateCount: 1,
        ),
        const SubjectAttendance(
          subjectCode: 'CSE-502',
          subject: 'Algorithms',
          teacher: 'Dr. Islam',
          totalClasses: 28,
          presentCount: 18,
          absentCount: 8,
          lateCount: 2,
        ),
        const SubjectAttendance(
          subjectCode: 'CSE-503',
          subject: 'Computer Networks',
          teacher: 'Prof. Karim',
          totalClasses: 25,
          presentCount: 22,
          absentCount: 3,
          lateCount: 0,
        ),
        const SubjectAttendance(
          subjectCode: 'CSE-504',
          subject: 'Database Systems',
          teacher: 'Mr. Hasan',
          totalClasses: 32,
          presentCount: 28,
          absentCount: 3,
          lateCount: 1,
        ),
        const SubjectAttendance(
          subjectCode: 'CSE-504L',
          subject: 'Database Lab',
          teacher: 'Mr. Hasan',
          totalClasses: 15,
          presentCount: 11,
          absentCount: 4,
          lateCount: 0,
        ),
      ];
}
