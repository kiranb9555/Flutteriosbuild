import 'dart:convert';

import 'package:Counselinks/module/signin.dart';
import 'package:Counselinks/shared/slide_right_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constant.dart';
import '../core/service_call.dart';
import '../core/util.dart';
import '../database/shared_pred_data.dart';
import '../model/user_login_response.dart';
import 'otp_verification.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController machineIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSavingData = false;
  String dropdownValue = 'Male';

  // late String dropDownValue;

  @override
  void initState() {
    getDeviceTokenToSendNotification();
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
      print(machineIdController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
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
    double width1 = Util().getScreenHeight(context);
    double width2 = Util().getScreenHeight(context) * 0.23;
    double height = Util().getScreenHeight(context) * 0.15;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: Util().boxDecoration(),
      child: Container(
        alignment: Alignment.topCenter,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getContainer(Alignment.center, _getLogo(height, width)),
                _detailForm("Enter Name...", "Name", width1, nameController),
                SizedBox(
                  height: height * 0.06,
                ),
                _detailForm("Enter Email...", "Email", width1, emailController),
                SizedBox(
                  height: height * 0.06,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _detailForm("Enter Mobile No....", "Mobile No.", width2,
                        mobileController),
                    _dropDownMenu(),
                    // DropdownButton<String>(
                    //   value: dropdownValue,
                    //   icon: const Icon(Icons.arrow_downward),
                    //   elevation: 16,
                    //   style: const TextStyle(color: Colors.deepPurple),
                    //   underline: Container(
                    //     height: 2,
                    //
                    //     color: Colors.deepPurpleAccent,
                    //   ),
                    //
                    //   onChanged: (String? newValue) {
                    //     setState(() {
                    //       dropdownValue = newValue!;
                    //     });
                    //   },
                    //   items: <String>['Male', 'Female', 'TransGender']
                    //       .map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    // ),
                  ],
                ),
                // SizedBox(
                //   height: height * 0.06,
                // ),
                // _detailForm("Enter Gender...", "Gender", width1,  genderController),
                SizedBox(
                  height: height * 0.06,
                ),
                _detailForm("Enter Password...", "Password", width1,
                    passwordController),
                SizedBox(
                  height: height * 0.06,
                ),
                !isSavingData ? _submitButton() : Util().loadIndicator(),
                _signIn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _dropDownMenu() {
    double fontSize = Util().getScreenHeight(context);
    return Container(
      width: 150.0,
      height: 60.0,
      child: DropdownButtonFormField<String>(
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: fontSize * 0.022,
        ),
        decoration: InputDecoration(
          labelText: "Gender",
          labelStyle: TextStyle(
            color: Colors.blueGrey.shade800,
            fontSize: fontSize * 0.022,
          ),
          hintText: "Select Gender",
          hintStyle: TextStyle(
            color: Colors.blueGrey.shade600,
          ),
          filled: true,
          fillColor: Colors.blueGrey.shade50,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Colors.blueGrey.shade900),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Colors.blueGrey.shade900),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Colors.blueGrey.shade900),
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(
                width: 1,
              )),
        ),
        value: dropdownValue,
        onChanged: (Value) {
          setState(() {
            dropdownValue = Value!;
            if (dropdownValue == "Male") {
              genderController.text = "101001";
              print(genderController.text);
            } else if (dropdownValue == "Female") {
              genderController.text = "101002";
              print(genderController.text);
            }
          });
        },
        items: <String>['Male', 'Female']
            .map((genderTitle) => DropdownMenuItem(
                value: genderTitle, child: Text("$genderTitle")))
            .toList(),
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
    return Image.asset(
      'assets/logo.png',
      height: height,
      width: width,
    );
  }



  _detailForm(String hintText, String labelText, double width,
      TextEditingController controller) {
    double fontSize = Util().getScreenHeight(context);
    return Container(
      width: width,
      child: TextFormField(
        validator: (value) => _validateField(value, labelText),
        controller: controller,
        cursorColor: Colors.blueGrey.shade900,
        cursorHeight: 20.0,
        keyboardType: labelText == "Mobile No." ? TextInputType.number : TextInputType.name,
        obscureText: labelText == "Password" ? true : false,
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: fontSize * 0.022,
        ),
        decoration: Util().inputDecoration(labelText, hintText, fontSize),
      ),
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
      }else if ( labelText == "Mobile No."){
        if (value.length != 10)
          return 'Mobile Number must be of 10 digit';
        else
          return null;
      }
    } else {
      return 'Please enter $labelText';
    }
  }





  _submitButton() {
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: Util().getTextWithStyle1(
          title: "Register".toUpperCase(),
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
        // Navigator.pushReplacement(
        //   context,
        //   SlideRightRoute(
        //     page: OtpVerification("1"),
        //   ),
        // );
        if (_formKey.currentState!.validate()) {
          setState(() {
            isSavingData = !isSavingData;
          });

          print(emailController.text + "  " + passwordController.text);

          _registerUser(
              machineIdController.text,
              0,
              nameController.text,
              emailController.text,
              mobileController.text,
              genderController.text,
              passwordController.text);
        }
      },
    );
  }

  _registerUser(
      machineId, userId, name, email, mobileNo, gender, password) async {
    Map<String, dynamic> userMap = {
      "objReqOutsideLogin": {
        "MachineId": machineId,
        "UserId": userId,
        "Name": name,
        "EmailId": email,
        "MobileNo1": mobileNo,
        "GenderId": gender.length == 0 ? 101001 : 101002,
        "Password": password,
        "CreatedBy": 1
      }
    };


    print("userMap123456");
    print(userMap);
    // setState(() {
    //   isSavingData = !isSavingData;
    // });
    ServiceCall()
        .apiCall(context, Constant.API_BASE_URL + Constant.API_SIGNUP_OUTSIDE,
            userMap)
        .then((value) {
      print("userMap124");
      print(value);
      // print("222222 PackageExpired : " + value['responseObject'][0]['PackageExpired'].toString());
      // print("22222223IsProfileUpdated : " + value['responseObject'][0]['IsProfileUpdated'].toString());
      // print("OTP : " + value['responseObject'][0]['OTP'].toString());
      // print("IsOTPVerified : " + value['responseObject'][0]['IsOTPVerified'].toString());
      // print("DisplayName : " + value['responseObject'][0]['DisplayName'].toString());
      // print("AppAccessTypeId : " + value['responseObject'][0]['AppAccessTypeId'].toString());
      // print("UserName : " + value['responseObject'][0]['UserName'].toString());
      // print("UserId : " + value['responseObject'][0]['UserId'].toString());
      // print("TermCondition : " + value['responseObject'][0]['TermCondition'].toString());
      // print("StateId : " + value['responseObject'][0]['StateId'].toString());
      // print("State : " + value['responseObject'][0]['State'].toString());
      // print("PackageTime : " + value['responseObject'][0]['PackageTime'].toString());
      // print("OldPassword : " + value['responseObject'][0]['OldPassword'].toString());
      // print("MobileNo1 : " + value['responseObject'][0]['MobileNo1'].toString());
      // print("GenderId : " + value['responseObject'][0]['GenderId'].toString());
      // print("EmailId : " + value['responseObject'][0]['EmailId'].toString());

      if (value["responseCode"] == "1") {
        if (value["responseObject"][0]["IsOTPVerified"] == 0) {
          print("not verified");
          UserLoginResponse userLoginResponse =
              UserLoginResponse.fromJson(value);
          String userData = jsonEncode(userLoginResponse);
          print(value['responseObject'][0]['OTP'].toString());
          String otp = value['responseObject'][0]['OTP'].toString();
          print("otp111 : " + otp);
          Navigator.pushReplacement(
            context,
            SlideRightRoute(
              page: OtpVerification(
                userData: userData,
                userEmail : email,
                password : password,
                machineId : machineId.toString(),
                otp : otp,
              ),
            ),
          );
        }else{
          Util().displayToastMsg("hello"+value["responseMessage"]);
        }
      } else if (value["responseCode"] == "0") {
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          isSavingData = !isSavingData;
        });
      }
    });
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
            SlideRightRoute(
              page: SignIn(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Util().getTextWithStyle(
                title: "Sign In",
                color: Colors.grey.shade900,
                fontSize: fontSize * 0.018,
                fontWeight: FontWeight.w500),
          ],
        ));
  }
}

/*
It is a full stack product development company having expertise in business management & communication application with a focus on latest technologies.
This Company works in Agriculture sector.
 */
