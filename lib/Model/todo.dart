class Todo {
  int userId;
  int id;
  String title;
  bool completed;

  Todo.fromJson(Map json)
      : userId = json['userId'],
        id = json['id'],
        title = json['title'],
        completed = json['completed'];

  Map toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
