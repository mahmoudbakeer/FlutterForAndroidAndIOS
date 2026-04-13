// lib/models/internship_model.dart
// Represents an internship posting by a company

class Internship {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final String requirements;
  final String duration;
  final String stipend;
  final String category;
  final DateTime postedDate;
  final String companyId;

  Internship({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.requirements,
    required this.duration,
    required this.stipend,
    required this.category,
    required this.postedDate,
    required this.companyId,
  });

  // Convert to/from Map for local storage simulation
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'requirements': requirements,
      'duration': duration,
      'stipend': stipend,
      'category': category,
      'postedDate': postedDate.toIso8601String(),
      'companyId': companyId,
    };
  }

  factory Internship.fromMap(Map<String, dynamic> map) {
    return Internship(
      id: map['id'],
      title: map['title'],
      company: map['company'],
      location: map['location'],
      description: map['description'],
      requirements: map['requirements'],
      duration: map['duration'],
      stipend: map['stipend'],
      category: map['category'],
      postedDate: DateTime.parse(map['postedDate']),
      companyId: map['companyId'],
    );
  }
}
