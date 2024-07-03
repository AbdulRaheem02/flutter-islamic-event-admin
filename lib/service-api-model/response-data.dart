// class ResponseData {
//   bool? status;
//   String? first_name;
//   String? token;

//   ResponseData({this.status, this.first_name,this.token});

//   ResponseData.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     first_name = json['first_name'];
//     token = json.containsKey("token") ? json['token'] :"";
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['first_name'] = first_name;
//     data['token'] = token;

//     return data;
//   }
// }
