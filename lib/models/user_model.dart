// lib/models/user_model.dart
// Represents a user in the system (Student or Company)

enum UserRole { student, company }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? bio;
  final String? university; // For students
  final String? companyName; // For companies

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.bio,
    this.university,
    this.companyName,
  });

  bool get isStudent => role == UserRole.student;
  bool get isCompany => role == UserRole.company;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'bio': bio,
      'university': university,
      'companyName': companyName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      role: UserRole.values.firstWhere((e) => e.name == map['role']),
      bio: map['bio'],
      university: map['university'],
      companyName: map['companyName'],
    );
  }
}
