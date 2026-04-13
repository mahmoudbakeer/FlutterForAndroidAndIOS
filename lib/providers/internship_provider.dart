// lib/providers/internship_provider.dart
// Manages internship listings and search

import 'package:flutter/material.dart';
import '../models/internship_model.dart';

class InternshipProvider extends ChangeNotifier {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // ─── Mock Data ────────────────────────────────────────────────────────────
  // In a real app, these would be fetched from Firebase Firestore or a REST API
  final List<Internship> _internships = [
    Internship(
      id: 'int1',
      title: 'Flutter Developer Intern',
      company: 'TechCorp Solutions',
      location: 'San Francisco, CA (Remote)',
      description:
          'Join our mobile team to build cross-platform applications using Flutter and Dart. '
          'You will work alongside senior engineers on real-world projects shipped to thousands of users.',
      requirements:
          'Knowledge of Dart/Flutter, basic understanding of REST APIs, familiarity with Git.',
      duration: '3 months',
      stipend: '\$1,500/month',
      category: 'Engineering',
      postedDate: DateTime(2025, 3, 10),
      companyId: 'company1',
    ),
    Internship(
      id: 'int2',
      title: 'Data Science Intern',
      company: 'DataWave Analytics',
      location: 'New York, NY',
      description:
          'Work with our data science team to analyze large datasets, build machine learning models, '
          'and present insights to stakeholders.',
      requirements:
          'Python, Pandas, basic statistics, Jupyter Notebook experience.',
      duration: '6 months',
      stipend: '\$2,000/month',
      category: 'Data Science',
      postedDate: DateTime(2025, 3, 5),
      companyId: 'company2',
    ),
    Internship(
      id: 'int3',
      title: 'UI/UX Design Intern',
      company: 'CreativeMinds Studio',
      location: 'Austin, TX (Hybrid)',
      description:
          'Design beautiful and intuitive user interfaces for web and mobile products. '
          'Collaborate with product managers and engineers to deliver user-centered designs.',
      requirements:
          'Figma, Adobe XD, basic prototyping skills, portfolio required.',
      duration: '4 months',
      stipend: '\$1,200/month',
      category: 'Design',
      postedDate: DateTime(2025, 2, 28),
      companyId: 'company3',
    ),
    Internship(
      id: 'int4',
      title: 'Backend Engineer Intern',
      company: 'CloudNest Technologies',
      location: 'Seattle, WA',
      description:
          'Build and maintain scalable backend services using Node.js and PostgreSQL. '
          'Learn DevOps practices including Docker and CI/CD pipelines.',
      requirements:
          'Node.js or Python, basic SQL, understanding of REST APIs.',
      duration: '3 months',
      stipend: '\$1,800/month',
      category: 'Engineering',
      postedDate: DateTime(2025, 3, 15),
      companyId: 'company4',
    ),
    Internship(
      id: 'int5',
      title: 'Marketing & Growth Intern',
      company: 'GrowthLabs Inc.',
      location: 'Remote',
      description:
          'Support our marketing team with content creation, social media management, '
          'SEO optimization, and email campaign execution.',
      requirements:
          'Strong writing skills, familiarity with Google Analytics, creativity.',
      duration: '3 months',
      stipend: '\$800/month',
      category: 'Marketing',
      postedDate: DateTime(2025, 3, 20),
      companyId: 'company5',
    ),
    Internship(
      id: 'int6',
      title: 'Machine Learning Intern',
      company: 'AIForward Labs',
      location: 'Boston, MA (Remote)',
      description:
          'Assist in developing and deploying ML models for natural language processing and '
          'computer vision tasks. Hands-on experience with PyTorch and TensorFlow.',
      requirements:
          'Python, basic ML knowledge, linear algebra, familiarity with PyTorch or TensorFlow.',
      duration: '6 months',
      stipend: '\$2,500/month',
      category: 'Data Science',
      postedDate: DateTime(2025, 3, 18),
      companyId: 'company6',
    ),
  ];

  // ─── Getters ──────────────────────────────────────────────────────────────
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<String> get categories => [
        'All',
        'Engineering',
        'Data Science',
        'Design',
        'Marketing',
      ];

  List<Internship> get filteredInternships {
    return _internships.where((i) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          i.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          i.company.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          i.location.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'All' || i.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Internship> get allInternships => List.unmodifiable(_internships);

  Internship? getById(String id) {
    try {
      return _internships.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Internship> getByCompanyId(String companyId) {
    return _internships.where((i) => i.companyId == companyId).toList();
  }

  // ─── Actions ──────────────────────────────────────────────────────────────
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addInternship(Internship internship) {
    _internships.add(internship);
    notifyListeners();
  }
}
