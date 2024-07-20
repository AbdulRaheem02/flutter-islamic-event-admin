class BookModel {
  BookModel({
    required this.id,
    required this.permanentDeleted,
    required this.title,
    required this.book,
    this.bookImage,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final bool permanentDeleted;
  late final String title;
  late final String book;
  String? bookImage;

  late final String createdAt;
  late final String updatedAt;

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    permanentDeleted = json['permanentDeleted'];
    title = json['title'];
    book = json['book'];
    bookImage = json['bookImage'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['permanentDeleted'] = permanentDeleted;
    data['title'] = title;
    data['bookImage'] = bookImage;

    data['book'] = book;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
