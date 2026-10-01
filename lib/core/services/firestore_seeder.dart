import 'package:cloud_firestore/cloud_firestore.dart';
import '../consts/app_constants.dart';
import '../models/notice_model.dart';
import '../models/routine_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreSeeder {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> seedInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isSeeded') == true) {
      return; // Already seeded
    }

    print("Seeding Firebase with initial data...");

    // 1. Seed Notices
    final notices = NoticeModel.dummyList;
    for (var notice in notices) {
      await _db.collection(AppConstants.noticesCollection).doc(notice.id).set(notice.toMap());
    }

    // 2. Seed Routine
    final routine = [RoutineModel.dummy];
    for (var r in routine) {
      await _db.collection(AppConstants.routinesCollection).add(r.toMap());
    }

    // Commented out because models don't have toMap() implemented yet
    // // 3. Seed Attendance
    // // 4. Seed Results
    // // 5. Seed Assignments

    await prefs.setBool('isSeeded', true);
    print("Seeding completed!");
  }
}
