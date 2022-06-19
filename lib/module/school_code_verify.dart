import 'package:Counselinks/module/school_login.dart';
import 'package:Counselinks/shared/slide_left_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../core/constant.dart';
import '../core/service_call.dart';
import '../core/util.dart';
import '../shared/slide_right_route.dart';
import 'signin.dart';

class SchoolCodeVerify extends StatefulWidget {
  const SchoolCodeVerify({Key? key}) : super(key: key);

  @override
  State<SchoolCodeVerify> createState() => _SchoolCodeVerifyState();
}

class _SchoolCodeVerifyState extends State<SchoolCodeVerify> {
  TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController schoolCodeController = TextEditingController();
  bool isCodeVerifying = false;
  dynamic schoolCodeResponse ;

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
            body: _schoolCodeBody(),
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
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            isCodeVerifying = !isCodeVerifying;
          });
          _getCompanyInfo(codeController.text);
        }
      },
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
      style: TextStyle(
        color: Colors.blueGrey,
        fontSize: fontSize * 0.022,
      ),
      decoration:  Util().inputDecoration(labelText, hintText, fontSize),
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
          isCodeVerifying = !isCodeVerifying;

        });
        Navigator.pushReplacement(
          context,
          SlideLeftRoute(
            page: SchoolLogin(response, codeController.text.toString()),
          ),
        );
      }else {
        Util().displayToastMsg(response['responseMessage']);
        setState(() {
          isCodeVerifying = !isCodeVerifying;
        });
      }
    });
  }
}
