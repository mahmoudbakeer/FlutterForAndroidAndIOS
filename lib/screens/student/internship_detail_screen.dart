// lib/screens/student/internship_detail_screen.dart
// Full internship details with Apply button and cover letter form

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/internship_model.dart';
import '../../models/application_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/application_provider.dart';
import '../../utils/app_theme.dart';

class InternshipDetailScreen extends StatefulWidget {
  final Internship internship;

  const InternshipDetailScreen({super.key, required this.internship});

  @override
  State<InternshipDetailScreen> createState() => _InternshipDetailScreenState();
}

class _InternshipDetailScreenState extends State<InternshipDetailScreen> {
  bool _isApplying = false;
  bool _applied = false;
  final _coverLetterController = TextEditingController();
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    final appProvider = context.read<ApplicationProvider>();
    if (user != null) {
      _applied = appProvider.hasApplied(user.id, widget.internship.id);
    }
  }

  @override
  void dispose() {
    _coverLetterController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (_coverLetterController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a cover letter')),
      );
      return;
    }

    setState(() => _isApplying = true);
    final user = context.read<AuthProvider>().currentUser!;
    final appProvider = context.read<ApplicationProvider>();

    await appProvider.apply(Application(
      id: 'app_${DateTime.now().millisecondsSinceEpoch}',
      internshipId: widget.internship.id,
      studentId: user.id,
      studentName: user.name,
      studentEmail: user.email,
      coverLetter: _coverLetterController.text.trim(),
      status: ApplicationStatus.pending,
      appliedDate: DateTime.now(),
    ));

    if (mounted) {
      setState(() {
        _isApplying = false;
        _applied = true;
        _showForm = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application submitted successfully! ✓'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final internship = widget.internship;

    return Scaffold(
      appBar: AppBar(title: const Text('Internship Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      internship.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      internship.company,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _infoRow(Icons.location_on_outlined, internship.location),
                    const SizedBox(height: 8),
                    _infoRow(Icons.access_time_outlined, 'Duration: ${internship.duration}'),
                    const SizedBox(height: 8),
                    _infoRow(Icons.attach_money_outlined, 'Stipend: ${internship.stipend}'),
                    const SizedBox(height: 8),
                    _infoRow(Icons.category_outlined, internship.category),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description
            _section('About the Role', internship.description),
            const SizedBox(height: 16),
            _section('Requirements', internship.requirements),
            const SizedBox(height: 24),

            // Cover Letter Form (toggleable)
            if (_showForm && !_applied) ...[
              const Text(
                'Cover Letter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _coverLetterController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Tell us why you are a great fit for this role...',
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _showForm = false),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isApplying ? null : _submitApplication,
                      child: _isApplying
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Submit'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Apply / Status Button
            if (!_showForm)
              _applied
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.success.withOpacity(0.4)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, color: AppTheme.success),
                          SizedBox(width: 8),
                          Text(
                            'Application Submitted',
                            style: TextStyle(
                              color: AppTheme.success,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () => setState(() => _showForm = true),
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('Apply Now'),
                    ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _section(String title, String content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                height: 1.6,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
