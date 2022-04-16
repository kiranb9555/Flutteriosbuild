import 'user_login_response_object.dart';

class UserLoginResponse {
  String? responseCode;
  String? responseMessage;
  List<UserLoginResponseObject>? responseObject;

  UserLoginResponse(
      {required this.responseCode, required this.responseMessage, required this.responseObject});

  UserLoginResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['responseObject'] != null) {
      responseObject = <UserLoginResponseObject>[];
      json['responseObject'].forEach((v) {
        responseObject!.add(new UserLoginResponseObject.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    if (this.responseObject != null) {
      data['responseObject'] =
          this.responseObject!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}