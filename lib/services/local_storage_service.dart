import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';
import '../models/class_session.dart';

class LocalStorageService {
  LocalStorageService._internal();
  static final LocalStorageService instance = LocalStorageService._internal();

  static const _eventsKey = 'events_cache';
  static const _classesKey = 'classes_cache';

  Future<void> saveEvents(List<Event> events) async {
    final prefs = await SharedPreferences.getInstance();
    final list = events.map((e) => e.toJson()).toList();
    await prefs.setString(_eventsKey, jsonEncode(list));
  }

  Future<List<Event>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_eventsKey);
    if (jsonString == null) return [];
    final List list = jsonDecode(jsonString);
    return list.map((e) => Event.fromJson(e)).toList();
  }

  Future<void> saveClassSessions(List<ClassSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final list = sessions.map((s) => s.toMap()).toList();
    await prefs.setString(_classesKey, jsonEncode(list));
  }

  Future<List<ClassSession>> loadClassSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_classesKey);
    if (jsonString == null) return [];
    final List list = jsonDecode(jsonString);
    return list.map((e) => ClassSession.fromMap(e)).toList();
  }
}
