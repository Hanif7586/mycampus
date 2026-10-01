// lib/core/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notice_model.dart';
import '../models/assignment_model.dart';
import '../consts/app_constants.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Notices ---
  Stream<List<NoticeModel>> getNotices({String? department}) {
    Query query = _db
        .collection(AppConstants.noticesCollection)
        .orderBy('isPinned', descending: true)
        .orderBy('createdAt', descending: true)
        .limit(AppConstants.pageSize);

    if (department != null && department != 'All') {
      query = query.where('department', whereIn: [department, 'All']);
    }

    return query.snapshots().map(
          (snap) => snap.docs
              .map((doc) => NoticeModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> postNotice(NoticeModel notice) async {
    await _db.collection(AppConstants.noticesCollection).add(notice.toMap());
  }

  Future<void> deleteNotice(String id) async {
    await _db.collection(AppConstants.noticesCollection).doc(id).delete();
  }

  // --- Assignments ---
  Stream<List<AssignmentModel>> getAssignments({
    required String department,
    required String semester,
    String? studentId,
  }) {
    return _db
        .collection(AppConstants.assignmentsCollection)
        .where('department', isEqualTo: department)
        .where('semester', isEqualTo: semester)
        .orderBy('deadline')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => AssignmentModel.fromFirestore(doc)).toList());
  }

  Future<void> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String note,
  }) async {
    await _db
        .collection(AppConstants.assignmentsCollection)
        .doc(assignmentId)
        .update({
      'status': 'submitted',
      'submissionNote': note,
      'submittedAt': FieldValue.serverTimestamp(),
      'studentId': studentId,
    });
  }

  // --- User ---
  Future<void> updateUserField({
    required String uid,
    required String field,
    required dynamic value,
  }) async {
    await _db
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .update({field: value});
  }

  // --- Generic CRUD ---
  Future<DocumentReference> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    return await _db.collection(collection).add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(collection).doc(docId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    await _db.collection(collection).doc(docId).delete();
  }

  Stream<QuerySnapshot> streamCollection({
    required String collection,
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query query = _db.collection(collection);
    if (filters != null) {
      for (final filter in filters) {
        query = query.where(filter.field,
            isEqualTo: filter.isEqualTo,
            isGreaterThan: filter.isGreaterThan,
            isLessThan: filter.isLessThan);
      }
    }
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots();
  }
}

class QueryFilter {
  final String field;
  final dynamic isEqualTo;
  final dynamic isGreaterThan;
  final dynamic isLessThan;

  const QueryFilter({
    required this.field,
    this.isEqualTo,
    this.isGreaterThan,
    this.isLessThan,
  });
}
