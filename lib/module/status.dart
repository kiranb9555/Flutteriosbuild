import 'dart:convert';

import 'package:Counselinks/core/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database/shared_pred_data.dart';
import '../shared/slide_left_route.dart';
import 'more.dart';

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
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
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = Util().getScreenHeight(context);
    return WillPopScope(
        child: Container(
          decoration: Util().boxDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: Util().getAppBar(context, "Status", height, height),
            body: _body(),
          ),
        ),
        onWillPop: ()async{
          Navigator.pushReplacement(
            context,
            SlideLeftRoute(
              page: More(),
            ),
          );
          return false;
        },
    );
  }

  _body(){
    return Container(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Column(
        children: [
          _getItems(key: "No. of Chats",value: userLoginData["responseObject"][0]["NoOfChat"].toString()),
          _getItems(key: "Package Expiry",value: userLoginData["responseObject"][0]["PackageTime"].toString()),
        ],
      ),
    );
  }



  _getItems({
    required String key,
    required String value,
  }){
    double _width = Util().getScreenWidth(context);
    double height = Util().getScreenHeight(context);
    double fontSize = Util().getScreenHeight(context);
    return Card(
      margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      color: const Color(0xFF91d0cc).withOpacity(1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 1.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        height: height / 20,
        width: _width,
        color: Colors.white38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Util().getTextWithStyle1(
                title: key,
                color: Colors.blueGrey.shade800,
                fontSize: fontSize * 0.021,
                fontWeight: FontWeight.w500),
            const SizedBox(
              width: 20.0,
            ),
            Util().getTextWithStyle1(
                title: value,
                color: Colors.blueGrey.shade800,
                fontSize: fontSize * 0.021,
                fontWeight: FontWeight.w500),
          ],
        ),
      ),
    );
  }
}
