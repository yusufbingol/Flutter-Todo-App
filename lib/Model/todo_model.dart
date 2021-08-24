class Todo {
  int? id;
  String title;
  String date;
  String priority;
  int status;

  Todo(
      {required this.title,
      required this.date,
      required this.priority,
      required this.status});
  Todo.withId(
      {this.id,
      required this.title,
      required this.date,
      required this.priority,
      required this.status});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['date'] = date;
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo.withId(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      priority: map['priority'],
      status: map['status'],
    );
  }
}
