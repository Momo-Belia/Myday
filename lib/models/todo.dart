enum TodoType { daily, special }

class Todo {
  final String id;
  final String title;
  final TodoType type;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime createdAt;
  final int? targetMinutes;

  Todo({
    required this.id,
    required this.title,
    required this.type,
    this.dueDate,
    this.isCompleted = false,
    required this.createdAt,
    this.targetMinutes,
  });

  Todo copyWith({
    String? id,
    String? title,
    TodoType? type,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
    int? targetMinutes,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      targetMinutes: targetMinutes ?? this.targetMinutes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type.index,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'targetMinutes': targetMinutes,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      title: map['title'] as String,
      type: TodoType.values[map['type'] as int],
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int)
          : null,
      isCompleted: (map['isCompleted'] as int) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      targetMinutes: map['targetMinutes'] as int?,
    );
  }

  static int? parseDurationFromTitle(String title) {
    final regex = RegExp(r'(\d+)\s*(小时|小时|hrs|hour|小时|h)');
    final match = regex.firstMatch(title);
    if (match != null) {
      return int.parse(match.group(1)!) * 60;
    }

    final regex2 = RegExp(r'(\d+)\s*(分钟|分钟|min|mins|m)');
    final match2 = regex2.firstMatch(title);
    if (match2 != null) {
      return int.parse(match2.group(1)!);
    }

    return null;
  }

  Map<String, dynamic> toJson() => toMap();

  factory Todo.fromJson(Map<String, dynamic> json) => Todo.fromMap(json);
}