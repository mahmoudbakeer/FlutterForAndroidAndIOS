// lib/providers/auth_provider.dart
// Handles user authentication using mock local data (no Firebase)
// In a production app, replace mock logic with Firebase Auth calls

import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Mock user database (simulates backend)
  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': 'student1',
      'name': 'Alice Johnson',
      'email': 'alice@student.com',
      'password': 'password123',
      'role': 'student',
      'university': 'MIT',
      'bio': 'Computer Science student passionate about software development.',
    },
    {
      'id': 'company1',
      'name': 'TechCorp Recruiter',
      'email': 'hr@techcorp.com',
      'password': 'password123',
      'role': 'company',
      'companyName': 'TechCorp Solutions',
      'bio': 'Leading software solutions company.',
    },
  ];

  // ─── Getters ──────────────────────────────────────────────────────────────
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ─── Login ────────────────────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final userMap = _mockUsers.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );

    if (userMap.isEmpty) {
      _errorMessage = 'Invalid email or password. Try alice@student.com / password123';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _currentUser = UserModel.fromMap(userMap);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // ─── Register ─────────────────────────────────────────────────────────────
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? university,
    String? companyName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    // Check for duplicate email
    final exists = _mockUsers.any((u) => u['email'] == email);
    if (exists) {
      _errorMessage = 'An account with this email already exists.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newUser = {
      'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'email': email,
      'password': password,
      'role': role.name,
      'university': university,
      'companyName': companyName,
      'bio': '',
    };

    _mockUsers.add(newUser);
    _currentUser = UserModel.fromMap(newUser);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // ─── Logout ───────────────────────────────────────────────────────────────
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
