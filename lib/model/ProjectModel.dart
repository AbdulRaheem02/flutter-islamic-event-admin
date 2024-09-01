class ProjectModel {
  ProjectModel({
    required this.id,
    required this.permanentDeleted,
    required this.title,
    required this.images,
    this.videos,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.lat,
    required this.long,
    required this.location,
    required this.organiserId,
    required this.about,
    required this.eventType,
    required this.userGoing,
    required this.createdAt,
    required this.updatedAt,
    this.organiserName,
    this.organiserPic,
  });
  late final String id;
  late final bool permanentDeleted;
  late final String title;
  late final List<dynamic> images;
  List<dynamic>? videos;

  late final String date;
  late final String startTime;
  late final String endTime;
  String? organiserPic;
  String? organiserName;

  late final String lat;
  late final String long;
  late final String location;
  late final OrganiserId organiserId;
  late final String about;
  late final String eventType;
  late final List<UserGoing> userGoing;
  late final String createdAt;
  late final String updatedAt;
  late final int _V;

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    permanentDeleted = json['permanentDeleted'];
    title = json['title'];
    organiserPic = json['organiserPic'];
    organiserName = json['organiserName'];

    images = List.castFrom<dynamic, dynamic>(json['pictures']);
    videos = List.castFrom<dynamic, dynamic>(json['videos']);

    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    lat = json['lat'];
    long = json['long'];
    location = json['location'];
    about = json['about'];
    // eventType = json['eventType'];
    userGoing =
        List.from(json['userGoing']).map((e) => UserGoing.fromJson(e)).toList();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    _V = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['permanentDeleted'] = permanentDeleted;
    data['title'] = title;
    data['organiserPic'] = organiserPic;
    data['organiserName'] = organiserName;

    data['pictures'] = images;
    data['videos'] = videos;

    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['lat'] = lat;
    data['long'] = long;
    data['location'] = location;
    data['organiserId'] = organiserId.toJson();
    data['about'] = about;
    data['eventType'] = eventType;
    data['userGoing'] = userGoing.map((e) => e.toJson()).toList();

    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = _V;
    return data;
  }
}

class OrganiserId {
  OrganiserId({
    required this.id,
    required this.fullname,
  });
  late final String id;
  late final String fullname;

  OrganiserId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    fullname = json['fullname'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['fullname'] = fullname;
    return data;
  }
}

class UserGoing {
  UserGoing({
    required this.userId,
    required this.amount,
    required this.id,
    this.phone,
  });
  late final UserId userId;
  late final int amount;
  String? phone;

  late final String id;

  UserGoing.fromJson(Map<String, dynamic> json) {
    userId = UserId.fromJson(json['userId']);
    amount = json['amount'];
    phone = json['phone'] ?? "";

    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId.toJson();
    data['amount'] = amount;
    data['phone'] = phone;
    data['_id'] = id;
    return data;
  }
}

class UserId {
  UserId({
    required this.id,
    required this.fullname,
  });
  late final String id;
  late final String fullname;

  UserId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    fullname = json['fullname'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['fullname'] = fullname;
    return data;
  }
}
