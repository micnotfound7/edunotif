import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/app_state.dart';
import 'services/notification_service.dart';
import 'auth/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Replace with your real Supabase keys
  await Supabase.initialize(
    url: 'https://lmukqicsexcmezgyxafc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtdWtxaWNzZXhjbWV6Z3l4YWZjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ1NzMxNjUsImV4cCI6MjA4MDE0OTE2NX0.qGamV9nyo1nHR9UlYUE4EI0rHuU5ZZIK_3h4bWWvUM0',
  );

  // Initialize notification service
  await NotificationService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Event Scheduler',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}
