import 'package:Counselinks/shared/slide_left_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../core/constant.dart';
import '../core/service_call.dart';
import '../core/util.dart';
import '../shared/slide_right_route.dart';
import 'signin.dart';

class SchoolLogin extends StatefulWidget {
  const SchoolLogin({Key? key}) : super(key: key);

  @override
  State<SchoolLogin> createState() => _SchoolLoginState();
}

class _SchoolLoginState extends State<SchoolLogin> {
  TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController schoolCodeController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSavingData = false;
  bool isCodeVerifying = false;
  bool isSchoolCodeVerified = false;
  var schoolCodeResponse ;

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
            body: isSchoolCodeVerified ? _schoolLoginBody() : _schoolCodeBody(),
          ),
        ),
      ),
    );
  }
/*
* School code verification
* */
  _schoolCodeBody() {
    double height = Util().getScreenHeight(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      // decoration: Util().boxDecoration(),
      child: Container(
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _detailForm(
                    "Enter School Code...", "School Code", codeController),
                SizedBox(
                  height: height * 0.06,
                ),
                !isCodeVerifying ? _schoolCodeButton() : Util().loadIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _schoolCodeButton() {
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: Util().getTextWithStyle1(
          title: "Next".toUpperCase(),
          color: Colors.grey.shade900,
          fontSize: fontSize * 0.02,
          fontWeight: FontWeight.w700,
      ),
      style: Util().buttonStyle(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF91d0cc).withOpacity(0.9),
          borderColor: const Color(0xFF91d0cc).withOpacity(0.7),
          borderRadius: 18.0),
      onPressed: () async {
        // String email = await SharedPrefData.getUserEmail();
        if (_formKey.currentState!.validate()) {
          setState(() {
            isCodeVerifying = !isCodeVerifying;
          });
          _getCompanyInfo(codeController.text);
        }
      },
    );
  }

  _getCompanyInfo(schoolCode) {
    Map<String, dynamic> schoolMap = {
      "objRequestCompanyBasicInfo": {
        "CompanyCode": schoolCode.toString().toUpperCase(),
      }
    };

    ServiceCall()
        .apiCall(context, Constant.API_BASE_URL + Constant.API_COMPANY_INFO,
        schoolMap)
        .then((response) {

      if (response['responseCode'] == "1") {
        setState(() {
          schoolCodeResponse = response;
          isCodeVerifying = !isCodeVerifying;
          isSchoolCodeVerified = !isSchoolCodeVerified;
        });
      }
    });
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
    return CachedNetworkImage(
      imageUrl: schoolCodeResponse['responseObject'][0]['CompanyLogo'].toString(),
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
      style: TextStyle(
        color: Colors.blueGrey,
        fontSize: fontSize * 0.022,
      ),
      decoration:  Util().inputDecoration(labelText, hintText, fontSize),
    );
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

  _getSchoolLogIn() async {
    Map<String, dynamic> schoolLoginMap = {
      "objReqSchoolUserLogin":{
        "MachineId":1,
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
            context, Constant.API_BASE_URL + Constant.API_LOGIN_SCHOOL, schoolLoginMap)
        .then((response) async {
      print("response555");
      print(response);
      if (response["responseCode"] == "1") {
        print("schoolLoginMap");
        print(schoolLoginMap);
        setState(() {
          isSavingData = !isSavingData;
        });
      } else if (response["responseCode"] == "0") {

        setState(() {
          isSavingData = !isSavingData;
        });
        print("response333");
        print(response);
        Util().displayToastMsg(response["responseMessage"]);
      }else{
        setState(() {
          isSavingData = !isSavingData;
        });
      }
    });
  }
}
