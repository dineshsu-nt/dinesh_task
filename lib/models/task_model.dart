class TaskModel {
  final String task;
  final String description;
   bool isCompleted;
  final String docID;

  TaskModel( {required this.docID,
    required this.isCompleted,
    required this.task,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "docId":docID,
      "isCompleted": isCompleted,
      'task': task,
      'description': description,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      docID: json["docId"],
      isCompleted: json["isCompleted"],
      task: json['task'],
      description: json['description'],
    );
  }
}
