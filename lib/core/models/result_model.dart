// lib/core/models/result_model.dart
class CourseResult {
  final String subjectCode;
  final String subject;
  final int creditHours;
  final double midMark;
  final double finalMark;
  final double internalMark;
  final double totalMark;
  final String grade;
  final double gradePoint;

  const CourseResult({
    required this.subjectCode,
    required this.subject,
    required this.creditHours,
    required this.midMark,
    required this.finalMark,
    required this.internalMark,
    required this.totalMark,
    required this.grade,
    required this.gradePoint,
  });

  factory CourseResult.fromMap(Map<String, dynamic> map) {
    return CourseResult(
      subjectCode: map['subjectCode'] ?? '',
      subject: map['subject'] ?? '',
      creditHours: map['creditHours'] ?? 3,
      midMark: (map['midMark'] ?? 0).toDouble(),
      finalMark: (map['finalMark'] ?? 0).toDouble(),
      internalMark: (map['internalMark'] ?? 0).toDouble(),
      totalMark: (map['totalMark'] ?? 0).toDouble(),
      grade: map['grade'] ?? 'F',
      gradePoint: (map['gradePoint'] ?? 0).toDouble(),
    );
  }

  static List<CourseResult> get dummyList => [
        const CourseResult(
          subjectCode: 'CSE-501',
          subject: 'Software Engineering',
          creditHours: 3,
          midMark: 28,
          finalMark: 52,
          internalMark: 15,
          totalMark: 83,
          grade: 'A-',
          gradePoint: 3.50,
        ),
        const CourseResult(
          subjectCode: 'CSE-502',
          subject: 'Algorithms',
          creditHours: 3,
          midMark: 30,
          finalMark: 58,
          internalMark: 18,
          totalMark: 91,
          grade: 'A+',
          gradePoint: 4.00,
        ),
        const CourseResult(
          subjectCode: 'CSE-503',
          subject: 'Computer Networks',
          creditHours: 3,
          midMark: 24,
          finalMark: 47,
          internalMark: 14,
          totalMark: 75,
          grade: 'B+',
          gradePoint: 3.25,
        ),
        const CourseResult(
          subjectCode: 'CSE-504',
          subject: 'Database Systems',
          creditHours: 3,
          midMark: 26,
          finalMark: 55,
          internalMark: 16,
          totalMark: 87,
          grade: 'A',
          gradePoint: 3.75,
        ),
        const CourseResult(
          subjectCode: 'CSE-504L',
          subject: 'Database Lab',
          creditHours: 1,
          midMark: 20,
          finalMark: 48,
          internalMark: 10,
          totalMark: 78,
          grade: 'B+',
          gradePoint: 3.25,
        ),
      ];
}

class ResultModel {
  final String id;
  final String studentId;
  final String semester;
  final String batch;
  final String department;
  final List<CourseResult> courses;
  final double cgpa;
  final double sgpa;

  const ResultModel({
    required this.id,
    required this.studentId,
    required this.semester,
    required this.batch,
    required this.department,
    required this.courses,
    required this.cgpa,
    required this.sgpa,
  });

  static ResultModel get dummy => ResultModel(
        id: '1',
        studentId: '2022-CSE-001',
        semester: '5th Semester',
        batch: '2022',
        department: 'CSE',
        courses: CourseResult.dummyList,
        cgpa: 3.72,
        sgpa: 3.64,
      );
}
