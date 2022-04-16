import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constant.dart';
import '../core/service_call.dart';
import '../core/util.dart';
import '../shared/slide_right_route.dart';
import 'home.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isUpdating = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
      Navigator.pushReplacement(
        context,
        SlideRightRoute(
          page: Home(),
        ),
      );
      return false;
    },
      child: Container(
        decoration: Util().boxDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Util().getUnderConstruction(context),
          ),
        ),
      ),
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
        .apiCall(context, Constant.API_BASE_URL + Constant.API_RESET_PASSWORD,
        userMap)
        .then((value) async {
      print("value1324");
      print(value);
      if (value["responseCode"] == "1") {

      } else if (value["responseCode"] == "0") {
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          isUpdating = !isUpdating;
        });
      }

      // print(value["responseObject"][0]["City"]);
      // print(value["responseObject"][0]["CounselingCategory"]);
    });
  }
}
