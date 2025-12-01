import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../theme/pastel_background.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool isSignup = false;
  bool loading = false;
  String? errorMessage;

  final _supabase = SupabaseService.instance;

  Future<void> _submit() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      if (isSignup) {
        await _supabase.signUp(_email.text.trim(), _password.text.trim());
      } else {
        await _supabase.signIn(_email.text.trim(), _password.text.trim());
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PastelBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isSignup ? "Create Account" : "Welcome Back",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // EMAIL FIELD
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // PASSWORD FIELD
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                // SUBMIT BUTTON
                ElevatedButton(
                  onPressed: loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(45),
                  ),
                  child: loading
                      ? const CircularProgressIndicator()
                      : Text(isSignup ? "Sign Up" : "Log In"),
                ),
                const SizedBox(height: 12),

                // SWITCH MODE
                TextButton(
                  onPressed: () {
                    setState(() => isSignup = !isSignup);
                  },
                  child: Text(
                    isSignup
                        ? "Already have an account? Log in"
                        : "Don't have an account? Sign up",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
