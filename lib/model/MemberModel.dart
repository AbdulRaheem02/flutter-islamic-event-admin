class MemberModel {
  MemberModel({
    required this.id,
    required this.email,
    required this.permanentDeleted,
    required this.fullname,
    required this.about,
    required this.phone,
    required this.image,
    required this.offers,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final bool permanentDeleted;
  late final String fullname;
  late final String email;

  late final String about;
  late final String phone;
  late final String image;
  late final List<dynamic> offers;
  late final String createdAt;
  late final String updatedAt;

  MemberModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    permanentDeleted = json['permanentDeleted'];
    fullname = json['fullname'];
    about = json['about'];
    phone = json['phone'];
    email = json['email'];

    image = json['image'];
    offers = json['offers'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['email'] = email;

    data['permanentDeleted'] = permanentDeleted;
    data['fullname'] = fullname;
    data['about'] = about;
    data['phone'] = phone;
    data['image'] = image;
    data['offers'] = offers;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
