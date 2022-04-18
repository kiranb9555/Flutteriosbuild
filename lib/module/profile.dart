import 'dart:convert';

import 'package:Counselinks/core/util.dart';
import 'package:Counselinks/module/more.dart';
import 'package:Counselinks/module/update_profile.dart';
import 'package:Counselinks/shared/slide_left_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database/shared_pred_data.dart';
import '../shared/bottom_navigation_widget.dart';
import '../shared/slide_right_route.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
        print("IsProfileUpdated13435");
        print(userLoginData['responseObject'][0]['IsProfileUpdated']);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = Util().getScreenWidth(context);
    double height = Util().getScreenHeight(context);
    double fontSize = Util().getScreenHeight(context);
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacement(
          context,
          SlideLeftRoute(
            page: More(),
          ),
        );
        return false;
      },
      child: Container(
        decoration: Util().boxDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: Util().getAppBar(context, 'Profile', fontSize, height),
          // bottomNavigationBar: BottomNavigationWidget(2),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                SlideRightRoute(
                  page: UpdateProfile(userLoginData),
                ),
              );
            },
            child: Icon(
              Icons.mode_edit_outline,
              color: Colors.white,
              size: 29,
            ),
            backgroundColor: Colors.teal,
            tooltip: 'Update Profile',
            elevation: 5,
            splashColor: Colors.grey,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,

          body: _body(),
        ),
      ),
    );
  }

  _body(){
    double width = Util().getScreenWidth(context);
    double height = Util().getScreenHeight(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
      // decoration: Util().boxDecoration(),
      child: Container(
        width: width,
        child: Column(
          children: [
            _getNameAndEmail(height, width),
            _getGenderAndDOB(height, width),
            _getAddress1(height, width),
            _getAddress2(height, width),
            _getStateCity(height, width),
            _getMobilePin(height, width),
            _geCategory(height, width),

            // Text(userLoginData['responseObject'][0]['Name']),
            // Text(userLoginData['responseObject'][0]['EmailId']),
            // Text(userLoginData['responseObject'][0]['MobileNo1']),
            // Text(userLoginData['responseObject'][0]['DOB']),
            // Text(userLoginData['responseObject'][0]['AddressLine1']),
            // Text(userLoginData['responseObject'][0]['AddressLine2']),
            // Text(userLoginData['responseObject'][0]['State']),
            // Text(userLoginData['responseObject'][0]['City']),
            // Text(userLoginData['responseObject'][0]['Pincode']),
            // Text(userLoginData['responseObject'][0]['Gender']),
            // Text(userLoginData['responseObject'][0]['CounselingCategory']),
          ],
        ),
      ),
    );
  }

  _getNameAndEmail(height, width) {
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
        height: height / 10,
        width: width,
        color: Colors.white38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 15.0,
            ),
            _getProfilePic(fontSize),
            SizedBox(
              width: 25.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                _getUserName(fontSize),
                SizedBox(
                  height: 5.0,
                ),
                _getUserEmail(fontSize),
                SizedBox(
                  height: 5.0,
                ),
                // _getFollowing(fontSize)
              ],
            )
          ],
        ),
      ),
    );
  }

  _getProfilePic(fontSize) {
    return Container(
      child: CircleAvatar(
        backgroundColor: Colors.teal,
        radius: 35,
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(35),
          ),
          child: Util().getTextWithStyle1(
              title: userLoginData['responseObject'][0]['Name']
                  .toString()[0]
                  .toUpperCase(),
              color: Colors.white,
              fontSize: fontSize * 0.049,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _getUserName(fontSize) {
    return Util().getTextWithStyle1(
        title: userLoginData['responseObject'][0]['Name'],
        color: Colors.blueGrey.shade900,
        fontSize: fontSize * 0.025,
        fontWeight: FontWeight.bold);
  }

  _getUserEmail(fontSize) {
    return Util().getTextWithStyle1(
        title: userLoginData['responseObject'][0]['EmailId'].toString(),
        color: Colors.blueGrey.shade900,
        fontSize: fontSize * 0.019,
        fontWeight: FontWeight.w500);
  }

  _getGenderAndDOB(height, width) {
    double fontSize = Util().getScreenHeight(context);
    return Card(
      margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      color: const Color(0xFF91d0cc).withOpacity(1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 2.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
        height: height / 15,
        width: width,
        color: Colors.white38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: width * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Util().getTextWithStyle1(
                    title: "Gender : ",
                    color: Colors.blueGrey.shade500,
                    fontSize: fontSize * 0.023,
                    fontWeight: FontWeight.w200),
                Util().getTextWithStyle1(
                    title:
                        userLoginData['responseObject'][0]['Gender'].toString(),
                    color: Colors.blueGrey.shade800,
                    fontSize: fontSize * 0.024,
                    fontWeight: FontWeight.w200)
              ],
            ),
            SizedBox(width: width * 0.10),
            Row(
              children: [
                Util().getTextWithStyle1(
                    title: "DOB : ",
                    color: Colors.blueGrey.shade500,
                    fontSize: fontSize * 0.023,
                    fontWeight: FontWeight.w200),
                Util().getTextWithStyle1(
                    title:userLoginData['responseObject'][0]['DOB'].toString() != "01-01-1900" ?  userLoginData['responseObject'][0]['DOB'].toString() : "",
                    color: Colors.blueGrey.shade800,
                    fontSize: fontSize * 0.024,
                    fontWeight: FontWeight.w200)
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getAddress1(height, width) {
    double fontSize = Util().getScreenHeight(context);
    return Card(
      margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      color: const Color(0xFF91d0cc).withOpacity(1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 2.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
        height: height / 15,
        width: width,
        color: Colors.white38,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Util().getTextWithStyle1(
                title: "Address Line 1 : ",
                color: Colors.blueGrey.shade500,
                fontSize: fontSize * 0.023,
                fontWeight: FontWeight.w200),
            Util().getTextWithStyle1(
                title: userLoginData['responseObject'][0]['AddressLine1']
                    .toString(),
                color: Colors.blueGrey.shade800,
                fontSize: fontSize * 0.024,
                fontWeight: FontWeight.w200)
          ],
        ),
      ),
    );
  }

  _getAddress2(height, width) {
    double fontSize = Util().getScreenHeight(context);
    return Card(
      margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      color: const Color(0xFF91d0cc).withOpacity(1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 2.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
        height: height / 15,
        width: width,
        color: Colors.white38,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Util().getTextWithStyle1(
                title: "Address Line 2 : ",
                color: Colors.blueGrey.shade500,
                fontSize: fontSize * 0.023,
                fontWeight: FontWeight.w200),
            Util().getTextWithStyle1(
                title: userLoginData['responseObject'][0]['AddressLine2']
                    .toString(),
                color: Colors.blueGrey.shade800,
                fontSize: fontSize * 0.024,
                fontWeight: FontWeight.w200)
          ],
        ),
      ),
    );
  }

  _getStateCity(height, width) {
    double fontSize = Util().getScreenHeight(context);
    return Card(
      margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      color: const Color(0xFF91d0cc).withOpacity(1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 2.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
        height: height / 15,
        width: width,
        color: Colors.white38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: width * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Util().getTextWithStyle1(
                    title: "State : ",
                    color: Colors.blueGrey.shade500,
                    fontSize: fontSize * 0.023,
                    fontWeight: FontWeight.w200),
                Util().getTextWithStyle1(
                    title:
                        userLoginData['responseObject'][0]['State'].toString(),
                    color: Colors.blueGrey.shade800,
                    fontSize: fontSize * 0.024,
                    fontWeight: FontWeight.w200)
              ],
            ),
            SizedBox(width: width * 0.10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Util().getTextWithStyle1(
                    title: "City : ",
                    color: Colors.blueGrey.shade500,
                    fontSize: fontSize * 0.023,
                    fontWeight: FontWeight.w200),
                Util().getTextWithStyle1(
                    title:
                        userLoginData['responseObject'][0]['City'].toString(),
                    color: Colors.blueGrey.shade800,
                    fontSize: fontSize * 0.024,
                    fontWeight: FontWeight.w200)
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getMobilePin(height, width) {
    double fontSize = Util().getScreenHeight(context);
    return Card(
      margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      color: const Color(0xFF91d0cc).withOpacity(1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 2.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
        height: height / 15,
        width: width,
        color: Colors.white38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: width * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Util().getTextWithStyle1(
                    title: "Pin : ",
                    color: Colors.blueGrey.shade500,
                    fontSize: fontSize * 0.023,
                    fontWeight: FontWeight.w200),
                Util().getTextWithStyle1(
                    title: userLoginData['responseObject'][0]['Pincode']
                        .toString(),
                    color: Colors.blueGrey.shade800,
                    fontSize: fontSize * 0.024,
                    fontWeight: FontWeight.w200)
              ],
            ),
            SizedBox(width: width * 0.27),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Util().getTextWithStyle1(
                    title: "Mobile : ",
                    color: Colors.blueGrey.shade500,
                    fontSize: fontSize * 0.023,
                    fontWeight: FontWeight.w200),
                Util().getTextWithStyle1(
                    title: userLoginData['responseObject'][0]['MobileNo1']
                        .toString(),
                    color: Colors.blueGrey.shade800,
                    fontSize: fontSize * 0.024,
                    fontWeight: FontWeight.w200)
              ],
            ),
          ],
        ),
      ),
    );
  }

  _geCategory(height, width) {
    double fontSize = Util().getScreenHeight(context);
    return Card(
      margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      color: const Color(0xFF91d0cc).withOpacity(1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 2.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
        height: height / 15,
        width: width,
        color: Colors.white38,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Util().getTextWithStyle1(
                title: "Category : ",
                color: Colors.blueGrey.shade500,
                fontSize: fontSize * 0.023,
                fontWeight: FontWeight.w200),
            Util().getTextWithStyle1(
                title: userLoginData['responseObject'][0]['CounselingCategory']
                    .toString(),
                color: Colors.blueGrey.shade800,
                fontSize: fontSize * 0.024,
                fontWeight: FontWeight.w200)
          ],
        ),
      ),
    );
  }
}
