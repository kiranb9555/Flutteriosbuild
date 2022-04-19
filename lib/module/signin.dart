import 'dart:convert';

import 'package:Counselinks/core/constant.dart';
import 'package:Counselinks/core/service_call.dart';
import 'package:Counselinks/model/user_login_response.dart';
import 'package:Counselinks/module/change_password.dart';
import 'package:Counselinks/module/forget_password.dart';
import 'package:Counselinks/module/home.dart';
import 'package:Counselinks/module/otp_verification.dart';
import 'package:Counselinks/module/school_login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/util.dart';
import '../database/shared_pred_data.dart';
import '../shared/slide_left_route.dart';
import '../shared/slide_right_route.dart';
import 'signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController machineIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSavingData = false;

  @override
  void initState() {
    getDeviceTokenToSendNotification();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    double fontSize = Util().getScreenHeight(context);

    // final email = TextFormField(
    //   validator: (value) => _validateField(value, labelText),
    //   controller: emailController,
    //   cursorColor: Colors.blueGrey.shade900,
    //   cursorHeight: 20.0,
    //   obscureText: true,
    //   style: TextStyle(
    //     color: Colors.blueGrey,
    //     fontSize: fontSize * 0.022,
    //   ),
    //   decoration: Util().inputDecoration(labelText, hintText, fontSize),
    // );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
          decoration: Util().boxDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: _body(),
          ),
        ),
      ),
    );
  }

  _body() {
    double width = Util().getScreenHeight(context) * 0.25;
    double height = Util().getScreenHeight(context) * 0.15;
    double fontSize = Util().getScreenHeight(context);
    return Container(
      // height: Util().getScreenHeight(context),context
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _getContainer(Alignment.center, _getLogo(height, width)),
              SizedBox(
                height: height * 0.01,
              ),
              _detailForm("Enter Email...", "Email", emailController),
              SizedBox(
                height: height * 0.06,
              ),
              _detailForm1("Enter Password...", "Password", passwordController),
              SizedBox(
                height: height * 0.06,
              ),
              !isSavingData ? _submitButton() : Util().loadIndicator(),
              _forgetPassword(),
              SizedBox(
                height: height * 0.15,
              ),
              _skipLogin(),
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _newUser(),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Util().getTextWithStyle1(
                      title: "OR",
                      color: Colors.grey.shade900,
                      fontSize: fontSize * 0.018,
                      fontWeight: FontWeight.w700),
                  const SizedBox(
                    width: 5.0,
                  ),
                  _schoolLogin()
                ],
              )
            ],
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
      height: size.height / 3,
      child: callMethod,
    );
  }

  _getLogo(height, width) {
    return Image.asset(
      'assets/logo.png',
      height: height,
      width: width,
    );
  }

  _detailForm(
      String hintText, String labelText, TextEditingController controller) {
    double fontSize = Util().getScreenHeight(context);
    return TextFormField(
      // onTap: () => print("email."),
      validator: (value) => _validateField(value, labelText),
      controller: controller,
      cursorColor: Colors.blueGrey.shade900,
      cursorHeight: 20.0,
      enabled: true,
      style: TextStyle(
        color: Colors.blueGrey,
        fontSize: fontSize * 0.022,
      ),
      decoration: Util().inputDecoration(labelText, hintText, fontSize),
    );
  }

  _validateField(value, labelText) {
    if (value != null && value.toString().isNotEmpty) {
      if (labelText == "Email") {
        var emailPattern =
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
        var match = RegExp(emailPattern, caseSensitive: false);
        if (match.hasMatch(value!)) {
          return null;
        } else {
          return 'Please enter valid email';
        }
      }
    } else {
      return 'Please enter $labelText';
    }
  }

  _detailForm1(
      String hintText, String labelText, TextEditingController controller) {
    double fontSize = Util().getScreenHeight(context);
    return TextFormField(
      validator: (value) => _validateField(value, labelText),
      controller: controller,
      cursorColor: Colors.blueGrey.shade900,
      cursorHeight: 20.0,
      obscureText: true,
      style: TextStyle(
        color: Colors.blueGrey,
        fontSize: fontSize * 0.022,
      ),
      decoration: Util().inputDecoration(labelText, hintText, fontSize),
    );
  }

  _submitButton() {
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: Util().getTextWithStyle1(
          title: "Sign In".toUpperCase(),
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

          // print(emailController.text + "  "+ passwordController.text);

          _loginUser(machineIdController.text, passwordController.text, emailController.text);
        }
      },
    );
  }

  _loginUser(machineId, password, userName) async {
    Map<String, dynamic> userMap = {
      "objReqOutsideLogin": {
        "MachineId": machineId,
        "Password": password,
        "UserName": userName
      }
    };

    print("userMap");
    print(userMap);
    ServiceCall()
        .apiCall(context, Constant.API_BASE_URL + Constant.API_LOGIN_OUTSIDE,
            userMap)
        .then((value) async {
      // print("222222 PackageExpired : " + value['responseObject'][0]['PackageExpired'].toString());
      // print("22222223IsProfileUpdated : " + value['responseObject'][0]['IsProfileUpdated'].toString());
      // print("value1324");
      // print(value);
      if (value["responseCode"] == "1") {
        //TODO : change IsOTPVerified after completion of resend otp and timer
        if (value["responseObject"][0]["IsOTPVerified"] == 0) {
          print("not verified");
          UserLoginResponse userLoginResponse =
              UserLoginResponse.fromJson(value);
          String userData = jsonEncode(userLoginResponse);
          String otp = value['responseObject'][0]['OTP'].toString();
          Navigator.pushReplacement(
            context,
            SlideRightRoute(
              page: OtpVerification(
                userData: userData,
                userName : userName,
                password : password,
                machineId : machineId.toString(),
                otp : otp
              ),
            ),
          );
        } else {
          UserLoginResponse userLoginResponse =
              UserLoginResponse.fromJson(value);
          String userData = jsonEncode(userLoginResponse);
          print("userLoginResponse1234");
          print(value['responseObject'][0]['IsProfileUpdated']);
          print(value['responseObject'][0]['IsOTPVerified']);
          print(value);
          SharedPrefData.setUserLoginData(userData);
          Util().displayToastMsg(value["responseMessage"]);

          SharedPrefData.setUserLoggedIn(true);
          SharedPrefData.setUserEmail(userName);
          SharedPrefData.setUserPassword(password);
          SharedPrefData.setMachineID(machineId.toString());

          Navigator.pushReplacement(
            context,
            SlideRightRoute(
              page: Home(),
            ),
          );
        }
      } else if (value["responseCode"] == "0") {
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          isSavingData = !isSavingData;
        });
      }

      // print(value["responseObject"][0]["City"]);
      // print(value["responseObject"][0]["CounselingCategory"]);
    });
  }

  _forgetPassword() {
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
              page: ForgetPassword(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Util().getTextWithStyle(
                title: "Forget Password",
                color: Colors.grey.shade900,
                fontSize: fontSize * 0.018,
                fontWeight: FontWeight.w500),
          ],
        ));
  }

  _skipLogin() {
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
              page: Home(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Util().getTextWithStyle(
                title: "Skip Sign In >>>",
                color: Colors.grey.shade900,
                fontSize: fontSize * 0.018,
                fontWeight: FontWeight.w600),
          ],
        ));
  }

  _newUser() {
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
              page: SignUp(),
            ),
          );
        },
        child: Row(
          children: [
            Util().getTextWithStyle(
                title: "New User",
                color: Colors.grey.shade900,
                fontSize: fontSize * 0.018,
                fontWeight: FontWeight.w700),
          ],
        ));
  }

  _schoolLogin() {
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
              page: SchoolLogin(),
            ),
          );
        },
        child: Row(
          children: [
            Util().getTextWithStyle(
                title: "School Login",
                color: Colors.grey.shade900,
                fontSize: fontSize * 0.018,
                fontWeight: FontWeight.w700),
          ],
        ));
  }
}
