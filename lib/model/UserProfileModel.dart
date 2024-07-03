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
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.companyName,
    required this.role,
    required this.paidMember,
    required this.permanentDeleted,
    required this.isSocialLogin,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceToken,
    this.profilePicture,
    this.sendEmail,
    this.bio,
    this.location,
    required this.V,
  });
  late final String id;
  late final String firstName;
  late final String lastName;
  late final String email;
  late final String phone;
  late final String companyName;
  late final String? bio;

  late final String role;
  late final bool paidMember;
  late final bool permanentDeleted;
  late final bool isSocialLogin;
  late final bool emailVerified;
  late final String createdAt;
  late final String updatedAt;
  late final String deviceToken;
  late final String? location;
  late final bool? sendEmail;

  late final String? profilePicture;

  late final int V;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    profilePicture = json['profilePicture']??"";
    bio = json['bio'];
    location = json['location'];

    companyName = json['companyName'];
    role = json['role'];
    paidMember = json['paidMember'];
    permanentDeleted = json['permanentDeleted'];
    isSocialLogin = json['isSocialLogin'];
    emailVerified = json['emailVerified'];
    sendEmail = json['sendEmail'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deviceToken = json['deviceToken'];

    V = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['email'] = email;
    _data['bio'] = bio;
    _data['profilePicture'] = profilePicture;
    _data['phone'] = phone;
    _data['location'] = location;
    _data['sendEmail'] = sendEmail;


    _data['companyName'] = companyName;
    _data['role'] = role;
    _data['paidMember'] = paidMember;
    _data['permanentDeleted'] = permanentDeleted;
    _data['isSocialLogin'] = isSocialLogin;
    _data['emailVerified'] = emailVerified;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['deviceToken'] = deviceToken;

    _data['__v'] = V;
    return _data;
  }
}
