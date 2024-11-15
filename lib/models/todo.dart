class Todo {
  final int? id;
  final String title;
  final String description;
  bool isCompleted;
  final DateTime? createdAt;

  Todo({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': (isCompleted) ? 1 : 0,
      'createdAt': createdAt != null
          ? createdAt!.toIso8601String()
          : DateTime.now().toIso8601String()
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        id: json['id'] as int?,
        title: json['title'] as String,
        description: json['description'] as String,
        isCompleted: (json['isCompleted'] as int?) == 1,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null);
  }

  Todo copy({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isCompleted: isCompleted ?? this.isCompleted,
        createdAt: createdAt ?? this.createdAt,
      );
}
