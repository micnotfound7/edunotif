import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event.dart';
import '../models/class_session.dart';

class SupabaseService {
  SupabaseService._internal();
  static final SupabaseService instance = SupabaseService._internal();

  final supabgit ase = Supabase.instance.client;

  /// AUTH ----------------------------------------------------

  Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  String? get currentUserId => supabase.auth.currentUser?.id;

  /// EVENTS ----------------------------------------------------

  Future<List<Event>> fetchEvents() async {
    final uid = currentUserId;
    if (uid == null) return [];

    final response = await supabase
        .from('events')
        .select('*')
        .eq('user_id', uid)
        .order('date_time', ascending: true);

    return (response as List)
        .map((row) => Event.fromMap(row))
        .toList();
  }

  Future<void> addEvent(Event event) async {
    await supabase.from('events').insert(event.toMap());
  }

  Future<void> updateEvent(Event event) async {
    await supabase
        .from('events')
        .update(event.toMap())
        .eq('id', event.id);
  }

  Future<void> deleteEvent(String id) async {
    await supabase.from('events').delete().eq('id', id);
  }

  /// CLASS SESSIONS ----------------------------------------------------

  Future<List<ClassSession>> fetchClassSessions() async {
    final uid = currentUserId;
    if (uid == null) return [];

    final response = await supabase
        .from('classes')
        .select('*')
        .eq('user_id', uid);

    return (response as List)
        .map((row) => ClassSession.fromMap(row))
        .toList();
  }

  Future<void> addClassSession(ClassSession session) async {
    await supabase.from('classes').insert(session.toMap());
  }

  Future<void> deleteClassSession(String id) async {
    await supabase.from('classes').delete().eq('id', id);
  }
}
