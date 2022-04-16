import 'dart:convert';

import 'package:Counselinks/core/constant.dart';
import 'package:Counselinks/core/service_call.dart';
import 'package:Counselinks/core/util.dart';
import 'package:Counselinks/shared/slide_left_route.dart';
import 'package:flutter/material.dart';

import '../database/shared_pred_data.dart';
import '../shared/slide_right_route.dart';
import 'home.dart';
import 'signin.dart';

class OtpVerification extends StatefulWidget {
  final String userData;
  final String userEmail;
  final String password;
  final String machineId;
  final String otp;

  const OtpVerification({
    Key? key,
    required this.userData,
    required this.userEmail,
    required this.password,
    required this.machineId,
    required this.otp,
  }) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isVerifyingOTP = false;
  dynamic userLoginData;

  @override
  void initState() {
    setState(() {
      userLoginData = jsonDecode(widget.userData);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("userId13");
    print(userLoginData);

    double height = Util().getScreenHeight(context);
    double fontSize = Util().getScreenHeight(context);
    return Container(
      decoration: Util().boxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar:
            Util().getAppBar1(context, "OTP Verification", fontSize, height),
        body: _body(height, fontSize),
      ),
    );
  }

  _body(height, fontSize) {
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
                _detailForm("Enter OTP...", "OTP", otpController),
                SizedBox(
                  height: height * 0.06,
                ),
                !isVerifyingOTP ? _submitButton() : Util().loadIndicator(),
                _resendOTP(fontSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _detailForm(
      String hintText, String labelText, TextEditingController controller) {
    double fontSize = Util().getScreenHeight(context);
    return Container(
      width: Util().getScreenWidth(context) * 0.5,
      child: TextFormField(
        validator: (value) {
          if (value != "") {
          } else {
            return 'Please enter $labelText';
          }

          return null;
        },
        controller: controller,
        cursorColor: Colors.blueGrey.shade900,
        cursorHeight: 20.0,
        keyboardType: TextInputType.number,
        // obscureText: labelText == "Email" ? false : true,
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: fontSize * 0.022,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.blueGrey.shade800,
            fontSize: fontSize * 0.022,
          ),
          hintText: hintText,
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
      ),
    );
  }

  _resendOTP(fontSize) {
    return InkWell(
        onTap: () async {
          // await SharedPrefData.removeEmail(SharedPrefData.userEmailKey);
          // await SharedPrefData.setUserLoggedIn(true);
          // await SharedPrefData.setDisplayDashboard(false);
          // await SharedPrefData.setWebsiteDetail(false);
          // await GoogleSignIn().disconnect();
          // FirebaseAuth.instance.signOut();
          // Navigator.pushReplacement(
          //   context,
          //   SlideRightRoute(
          //     page: SignIn(),
          //   ),
          // );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Util().getTextWithStyle(
                title: "Resend OTP",
                color: Colors.grey.shade900,
                fontSize: fontSize * 0.018,
                fontWeight: FontWeight.w500),
          ],
        ));
  }

  _submitButton() {
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: Util().getTextWithStyle1(
          title: "Verify".toUpperCase(),
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


          print("otp2222");
          print(otpController.text);
          print(widget.otp);

          if(otpController.text == widget.otp.toString()){
            // Util().displayToastMsg("Otp is 8521642377correct");
            setState(() {
              isVerifyingOTP = !isVerifyingOTP;
            });
            _verifyOtp(otpController.text);
          }else{
            Util().displayToastMsg("Otp is incorrect");
            // setState(() {
            //   isVerifyingOTP = !isVerifyingOTP;
            // });
          }

        }
      },
    );
  }

  _verifyOtp(otp) {
    Map<String, dynamic> otpMap = {
      "objReqSetOTPVerified": {
        "CompanyCode": "",
        "UserId": userLoginData['responseObject'][0]['UserId']
      }
    };
    print("otpMap124");
    print(otpMap);
    ServiceCall()
        .apiCall(context,
            Constant.API_BASE_URL + Constant.API_SET_USER_OTP_VERIFIED, otpMap)
        .then((value) async {
      if (value["responseCode"] == "1") {
        String userData = jsonEncode(userLoginData);
        SharedPrefData.setUserLoginData(userData);
        Util().displayToastMsg(value["responseMessage"]);

        SharedPrefData.setUserLoggedIn(true);
        SharedPrefData.setUserEmail(widget.userEmail);
        SharedPrefData.setUserPassword(widget.password);
        SharedPrefData.setMachineID(widget.machineId);
        Util().displayToastMsg(value["responseMessage"]);

        setState(() {
          isVerifyingOTP = !isVerifyingOTP;
        });

        Navigator.pushReplacement(
          context,
          SlideRightRoute(
            page: Home(),
          ),
        );
      } else if (value["responseCode"] == "0") {
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          isVerifyingOTP = !isVerifyingOTP;
        });
      }
    });
  }

  _resendOtp(){
    Map<String, dynamic> otpMap = {
      "objReqValidateAndGenrateOTP":{
        "CompanyCode":"",
        "UserName":"lucky1@gmail.com"
      }
    };
    print("otpMap124");
    print(otpMap);
    ServiceCall()
        .apiCall(context,
        Constant.API_BASE_URL + Constant.API_VALIDATE_GENERATE_OTP, otpMap)
        .then((value) async {
      print("value12324");
      print(value);
      if (value["responseCode"] == "1") {

        setState(() {
          isVerifyingOTP = !isVerifyingOTP;
        });
      } else if (value["responseCode"] == "0") {
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          isVerifyingOTP = !isVerifyingOTP;
        });
      }
    });
  }
}
