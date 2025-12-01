import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../services/supabase_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Correct provider usage
    final state = AppStateProvider.of(context);

    final supabase = SupabaseService.instance;
    final email = supabase.supabase.auth.currentUser?.email ?? "Unknown User";

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.person),
              title: Text("Account"),
            ),

            ListTile(
              title: Text(email),
            ),

            const Divider(),

            ElevatedButton.icon(
              onPressed: () async {
                await state.logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }
}
