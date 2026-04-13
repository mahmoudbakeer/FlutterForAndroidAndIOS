import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/application_provider.dart';
import '../../providers/internship_provider.dart';
import '../../models/application_model.dart';
import '../../utils/app_theme.dart';

class ViewApplicantsScreen extends StatelessWidget {
  const ViewApplicantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    final myInternships = context.watch<InternshipProvider>().getByCompanyId(user.id);
    final appProvider = context.watch<ApplicationProvider>();
    final allApps = myInternships.expand((i) => appProvider.getByInternshipId(i.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Applicants')),
      body: allApps.isEmpty
        ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.people_outline, size:72, color:AppTheme.divider),
            SizedBox(height:16),
            Text('No applicants yet', style:TextStyle(color:AppTheme.textSecondary, fontSize:16)),
          ]))
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: allApps.length,
            separatorBuilder: (_,__) => const SizedBox(height:10),
            itemBuilder: (ctx, i) {
              final app = allApps[i];
              final internship = myInternships.where((x) => x.id == app.internshipId).firstOrNull;
              return Card(child: Padding(padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    CircleAvatar(backgroundColor: AppTheme.primary.withOpacity(0.1),
                      child: Text(app.studentName[0], style: const TextStyle(color:AppTheme.primary, fontWeight:FontWeight.bold))),
                    const SizedBox(width:12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(app.studentName, style: const TextStyle(fontWeight:FontWeight.w700, fontSize:15)),
                      Text(app.studentEmail, style: const TextStyle(color:AppTheme.textSecondary, fontSize:13)),
                    ])),
                  ]),
                  const SizedBox(height:8),
                  if (internship != null)
                    Text('For: ${internship.title}', style: const TextStyle(color:AppTheme.primary, fontSize:13, fontWeight:FontWeight.w600)),
                  const SizedBox(height:10),
                  Row(children: [
                    _btn(ctx, app, appProvider, ApplicationStatus.accepted, AppTheme.success, 'Accept'),
                    const SizedBox(width:10),
                    _btn(ctx, app, appProvider, ApplicationStatus.rejected, AppTheme.error, 'Reject'),
                  ]),
                ]),
              ));
            }),
    );
  }

  Widget _btn(BuildContext ctx, Application app, ApplicationProvider prov,
      ApplicationStatus status, Color color, String label) {
    final isCurrent = app.status == status;
    return Expanded(child: OutlinedButton(
      onPressed: isCurrent ? null : () => prov.updateStatus(app.id, status),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: isCurrent ? color : AppTheme.divider),
        backgroundColor: isCurrent ? color.withOpacity(0.1) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    ));
  }
}
