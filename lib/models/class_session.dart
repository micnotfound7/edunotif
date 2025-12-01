class ClassSession {
  final String id;
  final String userId;
  final String title;
  final String instructor;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClassSession({
    required this.id,
    required this.userId,
    required this.title,
    required this.instructor,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClassSession.fromMap(Map<String, dynamic> map) {
    return ClassSession(
      id: map['id'].toString(),
      userId: map['user_id'],
      title: map['title'],
      instructor: map['instructor'] ?? '',
      startTime: DateTime.parse(map['start_time']),
      endTime: DateTime.parse(map['end_time']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'instructor': instructor,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ClassSession copyWith({
    String? title,
    String? instructor,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return ClassSession(
      id: id,
      userId: userId,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
