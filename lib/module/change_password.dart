import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constant.dart';
import '../core/service_call.dart';
import '../core/util.dart';
import '../database/shared_pred_data.dart';
import '../shared/slide_left_route.dart';
import '../shared/slide_right_route.dart';
import 'home.dart';
import 'more.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isUpdating = false;
  var userLoginResponse;
  dynamic userLoginData;

  @override
  void initState() {
    _getUserDetail();
    super.initState();
  }

  _getUserDetail() async {
    try {
      userLoginResponse = (await SharedPrefData.getUserLoginData())!;
      setState(() {
        userLoginData = jsonDecode(userLoginResponse);
        userIdController.text = userLoginData['responseObject'][0]['UserId'].toString();
        print("IsProfileUpdated13435");
        print(userIdController.text);
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
          SlideRightRoute(
            page: More(),
          ),
        );
        return false;
      },
        child: Container(
          decoration: Util().boxDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: Util().getAppBar(context, "Change Password", Util().getScreenHeight(context), Util().getScreenHeight(context)),
            body: Center(
              child: _body()
            ),
          ),
        ),
      ),
    );
  }

  _body(){
    double height = Util().getScreenHeight(context);
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

              _detailForm1("Enter Old Password...", "Old Password", oldPassController),
              SizedBox(
                height: height * 0.06,
              ),
              _detailForm1("Enter New Password...", "New Password", newPassController),
              SizedBox(
                height: height * 0.04,
              ),
              !isUpdating ? _submitButton() : Util().loadIndicator(),
              SizedBox(
                height: height * 0.15,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),

            ],
          ),
        ),
      ),
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
    if (value == null && value.toString().isEmpty) {
      return 'Please enter $labelText';
    }
    // return 'Please enter $labelText';
  }

  _submitButton() {
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: Util().getTextWithStyle1(
          title: "Change Password".toUpperCase(),
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
          print("oldPassController");
          print(oldPassController.text.toString().trim());
          print("newPassController");
          print(newPassController.text.toString().trim());
          if(oldPassController.text.toString().trim() != newPassController.text.toString().trim()){
            setState(() {
              isUpdating = !isUpdating;
            });
            _changePassword();
          }else{
            Util().displayToastMsg("New password must be different from old Password");
          }
        }
      },
    );
  }


  _changePassword() async {
    Map<String, dynamic> passMap = {
      "objReqOutsideLogin":{
        "OldPassword":oldPassController.text.toString(),
        "Password":newPassController.text.toString(),
        "UserId":int.parse(userIdController.text.toString())
      }
    };

    print("userMap");
    print(passMap);
    ServiceCall()
        .apiCall(context, Constant.API_BASE_URL + Constant.API_CHANGE_PASSWORD,
        passMap)
        .then((value) async {
      print("value1324");
      print(value);
      if (value["responseCode"] == "1") {
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          isUpdating = !isUpdating;
          _logout();
        });
      } else if (value["responseCode"] == "0") {
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          isUpdating = !isUpdating;
        });
      }
    });
  }

  _logout() async {
    await SharedPrefData.removeUserLoggedIn(SharedPrefData.userLoggedInKey);
    await SharedPrefData.removeTermCondition(SharedPrefData.termsConditionKey);
    await SharedPrefData.removeTcAccepted(SharedPrefData.tcAcceptedKey);
    await SharedPrefData.removeUserLoginData(SharedPrefData.userLoginDataKey);
    await SharedPrefData.removePackagesPurchaseData(
        SharedPrefData.packagePurchasedKey);
    await SharedPrefData.removeUserEmail(SharedPrefData.userEmailKey);
    await SharedPrefData.removeUserPassword(SharedPrefData.userPasswordKey);
    await SharedPrefData.removeMachineID(SharedPrefData.machineIDKey);
    // await SharedPrefData.removeProfileUpdate(SharedPrefData.profileUpdateKey);
    // await SharedPrefData.setUserLoggedIn(true);
    setState(() {
      isUpdating = !isUpdating;
      Util().displayToastMsg("Logged Out Successfully !!");
    });
    //
    Navigator.push(
      context,
      SlideLeftRoute(
        page: Home(),
      ),
    );
  }
}
