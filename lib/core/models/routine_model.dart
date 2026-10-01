// lib/core/models/routine_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassSlot {
  final String subject;
  final String subjectCode;
  final String teacher;
  final String room;
  final String startTime;
  final String endTime;
  final String type; // 'lecture', 'lab', 'tutorial'

  const ClassSlot({
    required this.subject,
    required this.subjectCode,
    required this.teacher,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.type,
  });

  factory ClassSlot.fromMap(Map<String, dynamic> map) {
    return ClassSlot(
      subject: map['subject'] ?? '',
      subjectCode: map['subjectCode'] ?? '',
      teacher: map['teacher'] ?? '',
      room: map['room'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      type: map['type'] ?? 'lecture',
    );
  }

  Map<String, dynamic> toMap() => {
        'subject': subject,
        'subjectCode': subjectCode,
        'teacher': teacher,
        'room': room,
        'startTime': startTime,
        'endTime': endTime,
        'type': type,
      };

  bool get isLab => type == 'lab';
  bool get isTutorial => type == 'tutorial';
}

class RoutineModel {
  final String id;
  final String department;
  final String batch;
  final String semester;
  final String section;
  final Map<String, List<ClassSlot>> schedule; // day -> slots
  final DateTime updatedAt;

  const RoutineModel({
    required this.id,
    required this.department,
    required this.batch,
    required this.semester,
    required this.section,
    required this.schedule,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    final scheduleMap = <String, dynamic>{};
    schedule.forEach((day, slots) {
      scheduleMap[day] = slots.map((s) => s.toMap()).toList();
    });
    return {
      'department': department,
      'batch': batch,
      'semester': semester,
      'section': section,
      'schedule': scheduleMap,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory RoutineModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final scheduleMap = <String, List<ClassSlot>>{};
    final rawSchedule = data['schedule'] as Map<String, dynamic>? ?? {};
    rawSchedule.forEach((day, slots) {
      scheduleMap[day] = (slots as List)
          .map((s) => ClassSlot.fromMap(s as Map<String, dynamic>))
          .toList();
    });
    return RoutineModel(
      id: doc.id,
      department: data['department'] ?? '',
      batch: data['batch'] ?? '',
      semester: data['semester'] ?? '',
      section: data['section'] ?? '',
      schedule: scheduleMap,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  List<ClassSlot> getSlotsForDay(String day) => schedule[day] ?? [];

  // Dummy data
  static RoutineModel get dummy => RoutineModel(
        id: '1',
        department: 'CSE',
        batch: '2022',
        semester: '5th',
        section: 'A',
        schedule: {
          'Sunday': [
            const ClassSlot(
              subject: 'Software Engineering',
              subjectCode: 'CSE-501',
              teacher: 'Dr. Rahman',
              room: 'R-301',
              startTime: '08:00',
              endTime: '09:30',
              type: 'lecture',
            ),
            const ClassSlot(
              subject: 'Computer Networks',
              subjectCode: 'CSE-503',
              teacher: 'Prof. Karim',
              room: 'R-205',
              startTime: '09:45',
              endTime: '11:15',
              type: 'lecture',
            ),
            const ClassSlot(
              subject: 'Database Lab',
              subjectCode: 'CSE-504L',
              teacher: 'Mr. Hasan',
              room: 'Lab-01',
              startTime: '11:30',
              endTime: '13:30',
              type: 'lab',
            ),
          ],
          'Monday': [
            const ClassSlot(
              subject: 'Algorithms',
              subjectCode: 'CSE-502',
              teacher: 'Dr. Islam',
              room: 'R-302',
              startTime: '08:00',
              endTime: '09:30',
              type: 'lecture',
            ),
            const ClassSlot(
              subject: 'Software Engineering',
              subjectCode: 'CSE-501',
              teacher: 'Dr. Rahman',
              room: 'R-301',
              startTime: '11:00',
              endTime: '12:30',
              type: 'tutorial',
            ),
          ],
          'Tuesday': [
            const ClassSlot(
              subject: 'Computer Networks',
              subjectCode: 'CSE-503',
              teacher: 'Prof. Karim',
              room: 'Lab-02',
              startTime: '08:00',
              endTime: '10:00',
              type: 'lab',
            ),
            const ClassSlot(
              subject: 'Algorithms',
              subjectCode: 'CSE-502',
              teacher: 'Dr. Islam',
              room: 'R-302',
              startTime: '10:30',
              endTime: '12:00',
              type: 'tutorial',
            ),
          ],
          'Wednesday': [
            const ClassSlot(
              subject: 'Database Systems',
              subjectCode: 'CSE-504',
              teacher: 'Mr. Hasan',
              room: 'R-201',
              startTime: '09:00',
              endTime: '10:30',
              type: 'lecture',
            ),
            const ClassSlot(
              subject: 'Software Engineering',
              subjectCode: 'CSE-501',
              teacher: 'Dr. Rahman',
              room: 'Lab-03',
              startTime: '11:00',
              endTime: '13:00',
              type: 'lab',
            ),
          ],
          'Thursday': [
            const ClassSlot(
              subject: 'Algorithms',
              subjectCode: 'CSE-502',
              teacher: 'Dr. Islam',
              room: 'R-302',
              startTime: '08:00',
              endTime: '09:30',
              type: 'lecture',
            ),
            const ClassSlot(
              subject: 'Database Systems',
              subjectCode: 'CSE-504',
              teacher: 'Mr. Hasan',
              room: 'R-201',
              startTime: '10:00',
              endTime: '11:30',
              type: 'lecture',
            ),
          ],
        },
        updatedAt: DateTime.now(),
      );
}
