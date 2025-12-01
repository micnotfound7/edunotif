class Event {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dateTime;
  final DateTime? reminderTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dateTime,
    this.reminderTime,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create an Event from Supabase row
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'].toString(),
      userId: map['user_id'],
      title: map['title'],
      description: map['description'] ?? '',
      dateTime: DateTime.parse(map['date_time']),
      reminderTime: map['reminder_time'] != null
          ? DateTime.parse(map['reminder_time'])
          : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  /// Convert Event to Map for Supabase insert/update
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'date_time': dateTime.toIso8601String(),
      'reminder_time': reminderTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Local JSON serialization
  Map<String, dynamic> toJson() => toMap();

  factory Event.fromJson(Map<String, dynamic> json) => Event.fromMap(json);

  Event copyWith({
    String? title,
    String? description,
    DateTime? dateTime,
    DateTime? reminderTime,
  }) {
    return Event(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
