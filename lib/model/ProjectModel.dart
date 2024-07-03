class ProjectModel {
  ProjectModel({
    required this.id,
    required this.permanentDeleted,
    required this.title,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final bool permanentDeleted;
  late final String title;
  late final List<String> images;
  late final String createdAt;
  late final String updatedAt;

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    permanentDeleted = json['permanentDeleted'];
    title = json['title'];
    images = List.castFrom<dynamic, String>(json['images']);
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['permanentDeleted'] = permanentDeleted;
    data['title'] = title;
    data['images'] = images;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
