import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/class_session.dart';
import '../services/supabase_service.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';

class AppState extends ChangeNotifier {
  AppState() {
    _initialize();
  }

  final _supabase = SupabaseService.instance;
  final _local = LocalStorageService.instance;
  final _notify = NotificationService.instance;

  List<Event> _events = [];
  List<Event> get events => _events;

  List<ClassSession> _classes = [];
  List<ClassSession> get classes => _classes;

  bool _loading = true;
  bool get loading => _loading;

  Future<void> _initialize() async {
    _loading = true;
    notifyListeners();

    try {
      await _loadFromSupabase();
    } catch (_) {
      await _loadFromLocal();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> _loadFromSupabase() async {
    final uid = _supabase.currentUserId;
    if (uid == null) {
      _events = [];
      _classes = [];
      return;
    }

    _events = await _supabase.fetchEvents();
    _classes = await _supabase.fetchClassSessions();

    await _local.saveEvents(_events);
    await _local.saveClassSessions(_classes);
  }

  Future<void> _loadFromLocal() async {
    _events = await _local.loadEvents();
    _classes = await _local.loadClassSessions();
  }

  // ----------------------------------------------------------
  // EVENT CRUD
  // ----------------------------------------------------------

  Future<void> addEvent({
    required String title,
    required String description,
    required DateTime dateTime,
    DateTime? reminderTime,
  }) async {
    final uid = _supabase.currentUserId;
    if (uid == null) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    final event = Event(
      id: id,
      userId: uid,
      title: title,
      description: description,
      dateTime: dateTime,
      reminderTime: reminderTime,
      createdAt: now,
      updatedAt: now,
    );

    await _supabase.addEvent(event);

    _events.add(event);
    await _local.saveEvents(_events);

    if (reminderTime != null) {
      await _notify.scheduleEventNotification(
        id: int.parse(id),
        title: title,
        body: description,
        time: reminderTime,
      );
    }

    notifyListeners();
  }

  Future<void> updateEvent(Event updated) async {
    await _supabase.updateEvent(updated);
    _events = _events.map((e) => e.id == updated.id ? updated : e).toList();
    await _local.saveEvents(_events);

    await _notify.cancelNotification(int.parse(updated.id));

    if (updated.reminderTime != null) {
      await _notify.scheduleEventNotification(
        id: int.parse(updated.id),
        title: updated.title,
        body: updated.description,
        time: updated.reminderTime!,
      );
    }

    notifyListeners();
  }

  Future<void> deleteEvent(String id) async {
    await _supabase.deleteEvent(id);
    _events.removeWhere((e) => e.id == id);
    await _local.saveEvents(_events);

    await _notify.cancelNotification(int.parse(id));
    notifyListeners();
  }

  // CLASS CRUD -----------------------------------------------

  Future<void> addClassSession({
    required String title,
    required String instructor,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final uid = _supabase.currentUserId;
    if (uid == null) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    final session = ClassSession(
      id: id,
      userId: uid,
      title: title,
      instructor: instructor,
      startTime: startTime,
      endTime: endTime,
      createdAt: now,
      updatedAt: now,
    );

    await _supabase.addClassSession(session);

    _classes.add(session);
    await _local.saveClassSessions(_classes);

    notifyListeners();
  }

  Future<void> deleteClassSession(String id) async {
    await _supabase.deleteClassSession(id);

    _classes.removeWhere((c) => c.id == id);
    await _local.saveClassSessions(_classes);

    notifyListeners();
  }

  // LOGOUT
  Future<void> logout() async {
    await _supabase.signOut();
    _events = [];
    _classes = [];
    notifyListeners();
  }
}

// ----------------------------------------------------------
// PROVIDER ACCESS — FIXED
// ----------------------------------------------------------

class AppStateProvider extends InheritedNotifier<AppState> {
  AppStateProvider({super.key, required Widget child})
      : super(notifier: AppState(), child: child);

  static AppState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppStateProvider>()!
        .notifier!;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) => true;
}
