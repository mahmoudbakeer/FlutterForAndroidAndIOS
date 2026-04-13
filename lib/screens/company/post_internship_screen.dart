import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/internship_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/internship_provider.dart';
import '../../utils/app_theme.dart';

class PostInternshipScreen extends StatefulWidget {
  const PostInternshipScreen({super.key});
  @override
  State<PostInternshipScreen> createState() => _PostInternshipScreenState();
}

class _PostInternshipScreenState extends State<PostInternshipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _location = TextEditingController();
  final _description = TextEditingController();
  final _requirements = TextEditingController();
  final _duration = TextEditingController();
  final _stipend = TextEditingController();
  String _category = 'Engineering';
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose(); _location.dispose(); _description.dispose();
    _requirements.dispose(); _duration.dispose(); _stipend.dispose();
    super.dispose();
  }

  void _post() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final user = context.read<AuthProvider>().currentUser!;
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    context.read<InternshipProvider>().addInternship(Internship(
      id: 'int_${DateTime.now().millisecondsSinceEpoch}',
      title: _title.text.trim(), company: user.companyName ?? user.name,
      location: _location.text.trim(), description: _description.text.trim(),
      requirements: _requirements.text.trim(), duration: _duration.text.trim(),
      stipend: _stipend.text.trim(), category: _category,
      postedDate: DateTime.now(), companyId: user.id,
    ));
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Internship posted! ✓'), backgroundColor: AppTheme.success));
    _title.clear(); _location.clear(); _description.clear();
    _requirements.clear(); _duration.clear(); _stipend.clear();
  }

  Widget _field(TextEditingController c, String label, IconData icon, {int maxLines=1}) =>
    TextFormField(controller: c, maxLines: maxLines,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: (v) => v==null||v.isEmpty ? 'Required' : null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Internship')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(key: _formKey, child: Column(children: [
          _field(_title, 'Job Title', Icons.work_outline),
          const SizedBox(height:14),
          _field(_location, 'Location', Icons.location_on_outlined),
          const SizedBox(height:14),
          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(labelText:'Category', prefixIcon: Icon(Icons.category_outlined)),
            items: ['Engineering','Data Science','Design','Marketing']
              .map((c) => DropdownMenuItem(value:c, child:Text(c))).toList(),
            onChanged: (v) => setState(() => _category = v!),
          ),
          const SizedBox(height:14),
          _field(_description, 'Description', Icons.description_outlined, maxLines:4),
          const SizedBox(height:14),
          _field(_requirements, 'Requirements', Icons.checklist_outlined, maxLines:3),
          const SizedBox(height:14),
          _field(_duration, 'Duration (e.g. 3 months)', Icons.access_time_outlined),
          const SizedBox(height:14),
          _field(_stipend, 'Stipend (e.g. \$1500/month)', Icons.attach_money_outlined),
          const SizedBox(height:24),
          ElevatedButton(
            onPressed: _loading ? null : _post,
            child: _loading
              ? const SizedBox(height:20,width:20,child:CircularProgressIndicator(color:Colors.white,strokeWidth:2))
              : const Text('Post Internship')),
        ])),
      ),
    );
  }
}
