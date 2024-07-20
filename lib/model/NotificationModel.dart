class NotificationModel {
  NotificationModel({
    required this.id,
    required this.permanentDeleted,
    required this.title,
    required this.body,
    required this.isRead,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final bool permanentDeleted;
  late final String title;
  late final String body;
  late final bool isRead;
  late final String type;
  late final String createdAt;
  late final String updatedAt;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    permanentDeleted = json['permanentDeleted'];
    title = json['title'];
    body = json['body'];
    isRead = json['isRead'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['permanentDeleted'] = permanentDeleted;
    data['title'] = title;
    data['body'] = body;
    data['isRead'] = isRead;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
