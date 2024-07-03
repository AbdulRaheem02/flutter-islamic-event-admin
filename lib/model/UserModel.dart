class AllUser {
  AllUser({
    required this.isSocialLogin,
    required this.emailVerified,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.companyName,
    required this.role,
    required this.paidMember,
    required this.permanentDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.bio,
    this.lat,
    this.profilePicture,
    this.lng,
    this.location,
    required this.V,
  });
  late final bool? isSocialLogin;
  late final bool? emailVerified;
  late final String? id;
  late final String? firstName;
  late final String? lastName;
  late final String? email;
  late final String? phone;
  late final String? companyName;
  late final String? role;
  late final String? profilePicture;

  late final bool? paidMember;
  late final bool? permanentDeleted;
  late final String? createdAt;
  late final String? updatedAt;
  late final String? deviceToken;
  late final String? lat;
  late final String? lng;
  late final String? location;

  late final String? bio;

  late final int? V;

  AllUser.fromJson(Map<String, dynamic> json) {
    isSocialLogin = json['isSocialLogin'];
    emailVerified = json['emailVerified'];
    id = json['_id'];
    profilePicture = json['profilePicture'];

    firstName = json['firstName'];
    bio = json['bio'];

    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    companyName = json['companyName'];
    role = json['role'];
    paidMember = json['paidMember'];
    permanentDeleted = json['permanentDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deviceToken = json['deviceToken'];
    lat = json['lat'];
    lng = json['long'];
    location = json['location'];

    V = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSocialLogin'] = isSocialLogin;
    data['emailVerified'] = emailVerified;
    data['_id'] = id;
    data['bio'] = bio;
    data['profilePicture'] = profilePicture;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['companyName'] = companyName;
    data['role'] = role;
    data['paidMember'] = paidMember;
    data['permanentDeleted'] = permanentDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = V;
    data['deviceToken'] = deviceToken;
    data['lat'] = lat;
    data['long'] = lng;
    data['location'] = location;

    return data;
  }
}
