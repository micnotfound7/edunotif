import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/main_navigation.dart';
import 'auth_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();

    // Listen for login/logout changes
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      return const AuthScreen();
    }

    return const MainNavigation();
  }
}
