// lib/models/application_model.dart
// Represents a student's application to an internship

enum ApplicationStatus { pending, accepted, rejected }

class Application {
  final String id;
  final String internshipId;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String coverLetter;
  final ApplicationStatus status;
  final DateTime appliedDate;

  Application({
    required this.id,
    required this.internshipId,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.coverLetter,
    required this.status,
    required this.appliedDate,
  });

  // Returns user-friendly status label
  String get statusLabel {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'internshipId': internshipId,
      'studentId': studentId,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'coverLetter': coverLetter,
      'status': status.name,
      'appliedDate': appliedDate.toIso8601String(),
    };
  }

  factory Application.fromMap(Map<String, dynamic> map) {
    return Application(
      id: map['id'],
      internshipId: map['internshipId'],
      studentId: map['studentId'],
      studentName: map['studentName'],
      studentEmail: map['studentEmail'],
      coverLetter: map['coverLetter'],
      status: ApplicationStatus.values.firstWhere(
        (e) => e.name == map['status'],
      ),
      appliedDate: DateTime.parse(map['appliedDate']),
    );
  }
}
