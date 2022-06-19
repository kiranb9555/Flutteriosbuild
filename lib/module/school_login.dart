import 'dart:convert';

import 'package:Counselinks/module/school_code_verify.dart';
import 'package:Counselinks/shared/slide_left_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../core/constant.dart';
import '../core/service_call.dart';
import '../core/util.dart';
import '../database/shared_pred_data.dart';
import '../model/user_login_response.dart';
import '../shared/slide_right_route.dart';
import 'home.dart';
import 'signin.dart';

class SchoolLogin extends StatefulWidget {
  dynamic schoolCodeResponse;
  String schoolCode = '';

  SchoolLogin(this.schoolCodeResponse, this.schoolCode , {Key? key}) : super(key: key);

  @override
  State<SchoolLogin> createState() => _SchoolLoginState();
}

class _SchoolLoginState extends State<SchoolLogin> {
  TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController schoolCodeController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController machineIdController = TextEditingController();
  bool isSavingData = false;
  bool isCodeVerifying = false;
  bool isSchoolCodeVerified = false;

  @override
  void initState() {
    getDeviceTokenToSendNotification();
    _getFilledData();
    super.initState();
  }

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    // deviceTokenToSendPushNotification = token.toString();
    print("Token Value ${token.toString()}");
    setState(() {
      machineIdController.text = token.toString();
      print("machine Id");
      print(machineIdController.text.length);
    });
  }


  _getFilledData(){
    print("schoolCode");
    print(widget.schoolCode.toString());
    schoolCodeController.text = widget.schoolCode.toString().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            SlideRightRoute(
              page: SignIn(),
            ),
          );
          return false;
        },
        child: Container(
          decoration: Util().boxDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: _schoolLoginBody(),
          ),
        ),
      ),
    );
  }

  /*School Login Code*/

  _schoolLoginBody() {
    double width = Util().getScreenHeight(context) * 0.25;
    double height = Util().getScreenHeight(context) * 0.15;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: Util().boxDecoration(),
      child: Container(
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getContainer(Alignment.center, _getLogo(height, width)),
                _detailForm("Enter School Code....", "School Code",
                    schoolCodeController),
                SizedBox(
                  height: height * 0.06,
                ),
                _detailForm(
                    "Enter User Name...", "User Name", userNameController),
                SizedBox(
                  height: height * 0.06,
                ),
                _detailForm(
                    "Enter Password...", "Password", passwordController),
                SizedBox(
                  height: height * 0.06,
                ),
                !isSavingData
                    ? _schoolLoginButton()
                    : Util().loadIndicator(),
                _signIn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getContainer(alignment, callMethod) {
    var size = MediaQuery.of(context).size;
    return Container(
      alignment: alignment,
      width: size.width,
      height: size.height / 4,
      child: callMethod,
    );
  }

  _getLogo(height, width) {
    print("imageUrl");
    print(widget.schoolCodeResponse['responseObject'][0]['CompanyLogo'].toString());
    return CachedNetworkImage(
      imageUrl: widget.schoolCodeResponse['responseObject'][0]['CompanyLogo'].toString(),
      placeholder: (context, url) => new CircularProgressIndicator(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
    );
      Image.asset(
      'assets/logo.png',
      height: height,
      width: width,
    );
  }

  _detailForm(
      String hintText, String labelText, TextEditingController controller) {
    double fontSize = Util().getScreenHeight(context);
    return TextFormField(
      validator: (value) => Util().validateField(value, labelText),
      controller: controller,
      cursorColor: Colors.blueGrey.shade900,
      cursorHeight: 20.0,
      obscureText: labelText == "Password" ? true : false,
      readOnly: _readOnly(labelText),
      style: TextStyle(
        color: Colors.blueGrey,
        fontSize: fontSize * 0.022,
      ),
      decoration:  Util().inputDecoration(labelText, hintText, fontSize),
    );
  }


  _readOnly(labelText){
    if (labelText == 'School Code') {
      return true;
    }else {
      return false;
    }
  }
  _schoolLoginButton() {
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: Util().getTextWithStyle1(
          title: "Login".toUpperCase(),
          color: Colors.grey.shade900,
          fontSize: fontSize * 0.02,
          fontWeight: FontWeight.w700),
      style: Util().buttonStyle(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF91d0cc).withOpacity(0.9),
          borderColor: const Color(0xFF91d0cc).withOpacity(0.7),
          borderRadius: 18.0),
      onPressed: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        // String email = await SharedPrefData.getUserEmail();
        if (_formKey.currentState!.validate()) {
          setState(() {
            isSavingData = !isSavingData;
          });

          print(userNameController.text + "  " + passwordController.text);

          _getSchoolLogIn();
        }
      },
    );
  }

  _signIn() {
    double fontSize = Util().getScreenHeight(context);
    return InkWell(
        onTap: () async {
          // await SharedPrefData.removeEmail(SharedPrefData.userEmailKey);
          // await SharedPrefData.setUserLoggedIn(true);
          // await SharedPrefData.setDisplayDashboard(false);
          // await SharedPrefData.setWebsiteDetail(false);
          // await GoogleSignIn().disconnect();
          // FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            SlideLeftRoute(
              page: SchoolCodeVerify(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Util().getTextWithStyle(
                title: "Back",
                color: Colors.grey.shade900,
                fontSize: fontSize * 0.018,
                fontWeight: FontWeight.w500),
          ],
        ));
  }

  _getSchoolLogIn() async {
    Map<String, dynamic> schoolLoginMap = {
      "objReqSchoolUserLogin": {
        "MachineId": machineIdController.text.toString(),
        "Password": passwordController.text.toString(),
        "UserName": userNameController.text.toString(),
        "CompanyCode": schoolCodeController.text.toString()
      }
    };

    print("schoolLoginMap");
    print(schoolLoginMap);
    /*
    * {responseCode: 1, responseMessage: Success, responseObject:
    * [{CompanyLogo: https://www.gdgoenkahighschool.com/assets/front/images/logo.png,
    * CompanyMasterId: 3, CompanyName: gd goenka school}]}
    * */
    ServiceCall()
        .apiCall(
        context, Constant.API_BASE_URL + Constant.API_LOGIN_SCHOOL,
        schoolLoginMap)
        .then((response) async {
      print("response555");
      print(response);
      if (response["responseCode"] == "1") {
        UserLoginResponse userLoginResponse =
        UserLoginResponse.fromJson(response);
        String userData = jsonEncode(userLoginResponse);
        SharedPrefData.setUserLoginData(userData);
        Util().displayToastMsg(response["responseMessage"]);

        SharedPrefData.setUserLoggedIn(true);
        SharedPrefData.setUserEmail(userNameController.text.toString());
        SharedPrefData.setUserPassword(passwordController.text.toString());
        SharedPrefData.setMachineID(machineIdController.text.toString());

        setState(() {
          isSavingData = !isSavingData;
        });

        Navigator.pushReplacement(
          context,
          SlideRightRoute(
            page: Home(),
          ),
        );
      } else {
        Util().displayToastMsg(response["responseMessage"]);
        setState(() {
          isSavingData = !isSavingData;
        });
      }
    });
  }
}
