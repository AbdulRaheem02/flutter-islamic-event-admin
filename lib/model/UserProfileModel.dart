class UserProfile {
  UserProfile({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final Data data;

  UserProfile.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final ddata = <String, dynamic>{};
    ddata['success'] = success;
    ddata['data'] = data.toJson();
    return ddata;
  }
}

class Data {
  Data({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });
  late final String id;
  late final String firstName;
  late final String lastName;
  late final String email;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['fullname'];
    lastName = json['fullname'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['fullname'] = firstName;
    data['fullname'] = lastName;
    data['email'] = email;

    return data;
  }
}
