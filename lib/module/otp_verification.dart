import 'dart:convert';

import 'package:Counselinks/core/constant.dart';
import 'package:Counselinks/core/service_call.dart';
import 'package:Counselinks/core/util.dart';
import 'package:Counselinks/shared/slide_left_route.dart';
import 'package:flutter/material.dart';

import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../database/shared_pred_data.dart';
import '../shared/slide_right_route.dart';
import 'home.dart';
import 'signin.dart';

class OtpVerification extends StatefulWidget {
  final String userData;
  final String userName;
  final String password;
  final String machineId;
  final String otp;

  const OtpVerification({
    Key? key,
    required this.userData,
    required this.userName,
    required this.password,
    required this.machineId,
    required this.otp,
  }) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  TextEditingController otpController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  CountdownController _controller = CountdownController(autoStart: true);

  final _formKey = GlobalKey<FormState>();
  bool isVerifyingOTP = false;
  bool isOTPSent = false;
  dynamic userLoginData;
  String resendOtp = "";
  bool isTimerEnded = true;
  bool isTimerStarted = false;
  int duration =  1;
  int minute1 = 0;
  int second1 = 0;

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
    return Stack(
      children: [
        Container(
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
                    _resendOTP(fontSize)
                  ],
                ),
              ),
            ),
          ),
        ),
        isOTPSent ? Util().loadIndicator() : Container()
      ],
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

          !isTimerEnded ? _getOtp() : Util().displayToastMsg("Resend Otp after sometimes.");
          setState(() {
            !isTimerEnded ? isOTPSent = !isOTPSent : isOTPSent;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // _otpTimer(fontSize)
            !isTimerEnded ? Util().getTextWithStyle(
              title: "Resend OTP",
              color: Colors.grey.shade900,
              fontSize: fontSize * 0.018,
              fontWeight: FontWeight.w500,
            ) : Container(),

            isTimerEnded ? Countdown(
              controller: _controller,
              seconds: 120,
              build: (_, double time) =>
                Util().getTextWithStyle(
                  title:  "Resend OTP (${time.toString()} s)",
                  color: Colors.grey.shade900,
                  fontSize: fontSize * 0.018,
                  fontWeight: FontWeight.w500,
                ),
              interval: const Duration(milliseconds: 100),
              onFinished: () {
                setState(() {
                  isTimerEnded = !isTimerEnded;
                });
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text('Timer is done!'),
                //   ),
                // );
              },
            ) : Container(),
          ],
        ));
  }

  _otpTimer(fontSize) {
    return isTimerEnded ? TweenAnimationBuilder<Duration>(
        duration: Duration(minutes: 1),
        tween: Tween(begin: Duration(minutes: duration), end: Duration.zero),
        onEnd: () {
          print('Timer ended');
         setState(() {
           isTimerEnded = ! isTimerEnded;
         });
        },
        builder: (BuildContext context, Duration value, Widget? child) {
          final minutes = value.inMinutes;
          final seconds = value.inSeconds % 60;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: isTimerEnded ? Util().getTextWithStyle(
              title: "Resend OTP ($minutes:$seconds)",
              color: Colors.grey.shade900,
              fontSize: fontSize * 0.018,
              fontWeight: FontWeight.w500,
            ) : Util().getTextWithStyle(
              title: "Resend OTP",
              color: Colors.grey.shade900,
              fontSize: fontSize * 0.018,
              fontWeight: FontWeight.w500,
            ),
          );
        },
    ) :
    TweenAnimationBuilder<Duration>(
        duration: Duration(minutes: 2),
        tween: Tween(begin: Duration(minutes: duration), end: Duration.zero),
        onEnd: () {
          print('Timer ended');
          setState(() {
            isTimerEnded = ! isTimerEnded;
          });
        },
        builder: (BuildContext context, Duration value, Widget? child) {
          final minutes = value.inMinutes;
          final seconds = value.inSeconds % 60;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: isTimerEnded ? Util().getTextWithStyle(
              title: "Resend OTP ($minutes:$seconds)",
              color: Colors.grey.shade900,
              fontSize: fontSize * 0.018,
              fontWeight: FontWeight.w500,
            ) : Util().getTextWithStyle(
              title: "Resend OTP",
              color: Colors.grey.shade900,
              fontSize: fontSize * 0.018,
              fontWeight: FontWeight.w500,
            ),
          );
        });
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

          if (otpController.text == widget.otp.toString() ||
              otpController.text == resendOtp) {
            // Util().displayToastMsg("Otp is 8521642377correct");
            setState(() {
              isVerifyingOTP = !isVerifyingOTP;
            });
            _verifyOtp(otpController.text);
          } else {
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
        SharedPrefData.setUserEmail(widget.userName);
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

  _getOtp() async {
    Map<String, dynamic> passMap = {
      "objReqValidateAndGenrateOTP": {
        "CompanyCode": "",
        "UserName": widget.userName.toString()
      }
    };

    print("userMap");
    print(passMap);
    ServiceCall()
        .apiCall(context,
            Constant.API_BASE_URL + Constant.API_VALIDATE_GENERATE_OTP, passMap)
        .then((value) async {
      print("value1324");
      print(value);
      if (value["responseCode"] == "1") {
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          if (resendOtp.isNotEmpty) {
            resendOtp = "";
          }
          resendOtp = value["responseObject"][0]["OTP"].toString();
          isOTPSent = !isOTPSent;
          _controller.onRestart;
          isTimerEnded = ! isTimerEnded;

        });
      } else if (value["responseCode"] == "0") {
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          isOTPSent = !isOTPSent;
        });
      }
    });
  }
}
