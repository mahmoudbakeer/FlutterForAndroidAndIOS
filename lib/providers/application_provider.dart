// lib/providers/application_provider.dart
// Manages internship applications

import 'package:flutter/material.dart';
import '../models/application_model.dart';

class ApplicationProvider extends ChangeNotifier {
  final List<Application> _applications = [];

  // ─── Getters ──────────────────────────────────────────────────────────────
  List<Application> getByStudentId(String studentId) {
    return _applications.where((a) => a.studentId == studentId).toList();
  }

  List<Application> getByInternshipId(String internshipId) {
    return _applications
        .where((a) => a.internshipId == internshipId)
        .toList();
  }

  bool hasApplied(String studentId, String internshipId) {
    return _applications.any(
      (a) => a.studentId == studentId && a.internshipId == internshipId,
    );
  }

  // ─── Actions ──────────────────────────────────────────────────────────────
  Future<void> apply(Application application) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    _applications.add(application);
    notifyListeners();
  }

  void updateStatus(String applicationId, ApplicationStatus newStatus) {
    final index = _applications.indexWhere((a) => a.id == applicationId);
    if (index != -1) {
      final old = _applications[index];
      _applications[index] = Application(
        id: old.id,
        internshipId: old.internshipId,
        studentId: old.studentId,
        studentName: old.studentName,
        studentEmail: old.studentEmail,
        coverLetter: old.coverLetter,
        status: newStatus,
        appliedDate: old.appliedDate,
      );
      notifyListeners();
    }
  }
}
