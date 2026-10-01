// lib/core/providers/notice_provider.dart
import 'package:flutter/material.dart';
import '../models/notice_model.dart';
import '../services/firestore_service.dart';

class NoticeProvider extends ChangeNotifier {

  List<NoticeModel> _notices = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';

  List<NoticeModel> get notices => _notices;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  List<NoticeModel> get filteredNotices {
    if (_selectedCategory == 'All') return _notices;
    return _notices
        .where((n) => n.category == _selectedCategory)
        .toList();
  }

  List<NoticeModel> get pinnedNotices =>
      _notices.where((n) => n.isPinned).toList();

  final FirestoreService _firestoreService = FirestoreService();

  NoticeProvider() {
    fetchNotices();
  }

  void fetchNotices() {
    setLoading(true);
    _firestoreService.getNotices().listen(
      (noticesData) {
        _notices = noticesData;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
