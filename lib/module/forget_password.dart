import 'dart:convert';

import 'package:Counselinks/module/signin.dart';
import 'package:Counselinks/shared/slide_left_route.dart';
import 'package:flutter/material.dart';

import '../core/constant.dart';
import '../core/service_call.dart';
import '../core/util.dart';
import '../database/shared_pred_data.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  final _otpFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  bool isUpdating = false;
  bool isOtp = false;
  var userLoginResponse;
  dynamic userLoginData;

  @override
  void initState() {
    // _getUserDetail();
    super.initState();
  }

  _getUserDetail() async {
    print("userNameController464464");
    try {
      userLoginResponse = (await SharedPrefData.getUserLoginData())!;
      print("userNameController344");
      print(userLoginResponse);
      setState(() {
        userLoginData = jsonDecode(userLoginResponse);
        userNameController.text = userLoginData['responseObject'][0]['UserName'].toString();
        print("userNameController");
        print(userNameController.text);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            SlideLeftRoute(
              page: SignIn(),
            ),
          );
          return false;
        },
        child: Container(
          decoration: Util().boxDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: Util().getAppBar(context, "Forget Password", Util().getScreenHeight(context), Util().getScreenHeight(context)),
            body: Center(
                child: _body()
            ),
          ),
        ),
      ),
    );
  }

  _body(){
    return Container(
      // height: Util().getScreenHeight(context),context
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _otpTxt(),
            _otpPassContainer()
          ],
        ),
      ),
    );
  }

  _otpTxt(){
    return Form(
        key: _otpFormKey,
        child: Column(
          children: [
            _detailForm2("Enter User Name...", "User Name", userNameController),
            SizedBox(
              height: MediaQuery.of(context).size.height *0.02,
            ),
            !isOtp ? _otpButton("Get OTP") : Util().loadIndicator(),
          ],
        )
    );
  }

  _otpPassContainer(){
    double height = Util().getScreenHeight(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          SizedBox(
            height: height * 0.06,
          ),
          _detailForm("Enter OTP...", "OTP", otpController),
          SizedBox(
            height: height * 0.03,
          ),
          _detailForm1("Enter New Password...", "New Password", newPassController),
          SizedBox(
            height: height * 0.04,
          ),
          !isUpdating ? _submitButton("Update Password") : Util().loadIndicator(),
          SizedBox(
            height: height * 0.15,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 5,
          ),

        ],
      ),
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

  _detailForm2(
      String hintText, String labelText, TextEditingController controller) {
    double fontSize = Util().getScreenHeight(context);
    return TextFormField(
      // onTap: () => print("email."),
      // validator: (value) => _validateField(value, labelText),
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

  _validateField(value, labelText) {
    if (value != null && value.toString().isNotEmpty) {
      // if (labelText == "Email") {
      //   var emailPattern =
      //       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
      //   var match = RegExp(emailPattern, caseSensitive: false);
      //   if (match.hasMatch(value!)) {
      //     return null;
      //   } else {
      //     return 'Please enter valid email';
      //   }
      // }
    } else {
      return 'Please enter $labelText';
    }
  }

  _otpButton(title) {
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: Util().getTextWithStyle1(
          title: title.toUpperCase(),
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
        setState(() {
          isOtp = !isOtp;
        });
        _getOtp();
      },
    );
  }

  _getOtp() async {
    Map<String, dynamic> passMap = {
      "objReqValidateAndGenrateOTP":{
        "CompanyCode":"",
        "UserName":userNameController.text
      }
    };

    print("userMap");
    print(passMap);
    ServiceCall()
        .apiCall(context, Constant.API_BASE_URL + Constant.API_VALIDATE_GENERATE_OTP,
        passMap)
        .then((value) async {
      print("value1324");
      print(value);
      if (value["responseCode"] == "1") {
        Util().displayToastMsg(value["responseMessage"]);
        userIdController.text = value["responseObject"][0]["UserId"].toString();
        otp1Controller.text = value["responseObject"][0]["OTP"].toString();
        setState(() {
          isOtp = !isOtp;
        });

      } else if (value["responseCode"] == "0") {
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          isOtp = !isOtp;
        });
      }
    });
  }

  _submitButton(title) {
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: Util().getTextWithStyle1(
          title: title.toUpperCase(),
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
        print("otp1343");
        if (_formKey.currentState!.validate()) {
          print("otp1111");
          print(otpController.text);
          print(otp1Controller.text);
          if(otpController.text == otp1Controller.text){
            setState(() {
              isUpdating = !isUpdating;
            });
            _forgetPassword();
          }else{
            // setState(() {
            //   isUpdating = !isUpdating;
            // });
            Util().displayToastMsg("OTP is Incorrect ...");
          }

        }
      },
    );
  }

  _forgetPassword() async {
    Map<String, dynamic> passMap = {
      "objReqValidateAndGenrateOTP":{
        "CompanyCode":"",
        "UserId":userIdController.text,
        "OTP": otpController.text,
        "Password": newPassController.text
      }
    };

    print("userMap");
    print(passMap);
    ServiceCall()
        .apiCall(context, Constant.API_BASE_URL + Constant.API_RESET_PASSWORD,
        passMap)
        .then((value) async {
      print("value1324");
      print(value);
      if (value["responseCode"] == "1") {
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          isUpdating = !isUpdating;
        });
        Navigator.pushReplacement(
          context,
          SlideLeftRoute(
            page: SignIn(),
          ),
        );
      } else if (value["responseCode"] == "0") {
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          isUpdating = !isUpdating;
        });
      }
    });
  }
}
