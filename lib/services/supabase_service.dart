import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event.dart';
import '../models/class_session.dart';

class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  final SupabaseClient supabase = Supabase.instance.client;

  // ---------------- EVENTS ----------------

  Future<List<Event>> fetchEvents() async {
    final response = await supabase.from('events').select();
    return (response as List).map((e) => Event.fromMap(e)).toList();
  }

  Future<void> addEvent(Event event) async {
    await supabase.from('events').insert(event.toMap());
  }

  Future<void> updateEvent(Event event) async {
    await supabase.from('events').update(event.toMap()).eq('id', event.id);
  }

  Future<void> deleteEvent(String id) async {
    await supabase.from('events').delete().eq('id', id);
  }

  // ---------------- CLASS SESSIONS ----------------

  Future<List<ClassSession>> fetchClassSessions() async {
    final response = await supabase.from('classes').select();
    return (response as List).map((e) => ClassSession.fromMap(e)).toList();
  }

  Future<void> addClassSession(ClassSession session) async {
    await supabase.from('classes').insert(session.toMap());
  }

  Future<void> deleteClassSession(String id) async {
    await supabase.from('classes').delete().eq('id', id);
  }

  // ---------------- AUTH ----------------

  Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async => await supabase.auth.signOut();

  String? get currentUserId => supabase.auth.currentUser?.id;
}
