import 'dart:convert';

import 'package:Counselinks/core/service_call.dart';
import 'package:Counselinks/module/package_list.dart';
import 'package:Counselinks/module/update_profile.dart';
import 'package:Counselinks/shell/exit_app_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/constant.dart';
import '../core/util.dart';
import '../database/shared_pred_data.dart';
import '../model/user_login_response.dart';
import '../shared/bottom_navigation_widget.dart';
import '../shared/slide_right_route.dart';
import '../shared/webPage.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var userLoginResponse;
  dynamic userLoginData;
  int packageExpired = 0;
  int profileUpdated = 0;
  int userId = 0;
  int appAccessTypeId = 0;
  int lang = 0;
  var isPackagePurchased;
  bool _isPackagePurchased = false;
  bool _isChatLinkDisplayed = false;
  bool _isLoading = false;
  bool _isLangSelected = false;

  @override
  void initState() {
    _getAccountStatus();
    super.initState();
  }

  _getAccountStatus() async {
    try {
      userLoginResponse = (await SharedPrefData.getUserLoginData())!;

      isPackagePurchased =
          (await SharedPrefData.getPackagesPurchaseData()) != null
              ? (await SharedPrefData.getPackagesPurchaseData())
              : false;
      setState(() {
        userLoginData = jsonDecode(userLoginResponse);
        profileUpdated = userLoginData['responseObject'][0]['IsProfileUpdated'];
        packageExpired = userLoginData['responseObject'][0]['PackageExpired'];
        userId = userLoginData['responseObject'][0]['UserId'];
        appAccessTypeId = userLoginData['responseObject'][0]['AppAccessTypeId'];
        _isPackagePurchased = isPackagePurchased;
        print('isPackagePurchased');
        print(_isPackagePurchased);


      });
      if (profileUpdated == 1 && packageExpired == 0) {
        _langAlertDialogWidget();
      }
      if (profileUpdated == 0) {
        Util().displayToastMsg("Please Complete Your Profile");
        Navigator.pushReplacement(
          context,
          SlideRightRoute(
            page: UpdateProfile(userLoginData),
          ),
        );
      }
      if (packageExpired == 1) {
        setState(() {
          packageExpired = userLoginData['responseObject'][0]['PackageExpired'];
          userId = userLoginData['responseObject'][0]['UserId'];
        });
        // _purchasePackageAlertDialogWidget();
      } else {
        print('PackageExpired');
        print(userLoginData['responseObject'][0]['UserId']);
      }
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    double height = Util().getScreenHeight(context);
    double fontSize = Util().getScreenHeight(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        decoration: Util().boxDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: Util().getAppBar(context, "Chat", fontSize, height),
          bottomNavigationBar: BottomNavigationWidget(1),
          body: _body(),
        ),
      ),
    );
  }

  _body() {
    return Container(
      child: _displayWidget(),
    );
  }

  Widget _displayWidget() {

    try {
      if (profileUpdated == 1 && packageExpired == 0) {
        String chatUrl = "https://counselinks.com/CounseLink/CouselinkChat/?AppAccessId=$userId&LanguageId=$lang&AppAccessTypeId=$appAccessTypeId";
        print("chatUrl");
        print(chatUrl);
        return _isLangSelected ? WebPage(chatUrl) : Center(
          child: Text("Please Select Language"),
        );
      }
      // if(profileUpdated == 0){
      //   Navigator.pushReplacement(
      //     context,
      //     SlideRightRoute(
      //       page: UpdateProfile(userLoginData),
      //     ),
      //   );
      // }
      if (packageExpired == 1) {
        return Center(
          child: contentBox(
            context,
            'Alert !!!',
            'Purchase package first for use this application further',
            "Purchase",
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    return Container();
  }

  _langAlertDialogWidget() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return _openDialog();
      },
    );
  }

  _openDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constant.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: languageList(),
    );
  }

  languageList() {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: const Color(0xFF91d0cc).withOpacity(0.8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Util().getTextWithStyle1(
              title: "Select Language",
              color: Colors.blueGrey.shade500,
              fontSize: Util().getScreenHeight(context) * 0.027,
              fontWeight: FontWeight.w600,
          ),
          // _languageCard("Select Language"),
            _languageCard("English"),
            _languageCard("Hindi"),
            _languageCard("Gujarati"),
        ],
      ),
    );
  }

  _languageCard(title) {
    double height = Util().getScreenHeight(context);
    double width = Util().getScreenWidth(context);
    return Container(
      // height: Util().getScreenHeight(context),
      child: GestureDetector(
        onTap: () => _selectLang(title),
        child: Card(
            margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            color: const Color(0xFF91d0cc).withOpacity(1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 1.0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              height: height / 20,
              width: width,
              color: Colors.white38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      Util().getTextWithStyle1(
                          title: title,
                          color: Colors.blueGrey.shade800,
                          fontSize: height * 0.021,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blueGrey.shade800,
                    size: height * 0.02,
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }

  _selectLang(title){
    if(title == "English"){
      setState(() {
        lang = 1;
        _isLangSelected = true;
      });

      print("22222222lanhu");
      print(lang);
      Navigator.pop(context);
    }else if(title == "Hindi"){
      setState(() {
        lang = 2;
        _isLangSelected = true;
      });
      print("22222222lanhu");
      print(lang);
      Navigator.pop(context);
    }else if(title == "Gujarati"){
      setState(() {
        lang = 3;
        _isLangSelected = true;
      });
      print("22222222lanhu");
      print(lang);
      Navigator.pop(context);
    }
  }

  contentBox(context, title, description, purchase) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFF91d0cc).withOpacity(0.8),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Util().getTextWithStyle1(
                  title: title,
                  color: Colors.red.shade900,
                  fontSize: width * 0.047,
                  fontWeight: FontWeight.w800),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                child: Util().getTextWithStyle1(
                    title: description,
                    color: Colors.blueGrey.shade800,
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: height * 0.032,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RaisedButton(
                    color: Colors.teal.shade200,
                    // padding: EdgeInsets.fromLTRB(70, 15, 70, 15),
                    padding: EdgeInsets.only(
                        left: width * 0.16,
                        right: width * 0.16,
                        bottom: 15,
                        top: 15),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Util().getTextWithStyle1(
                        title: purchase.toUpperCase(),
                        color: Colors.grey.shade900,
                        fontSize: width * 0.055,
                        fontWeight: FontWeight.w900),

                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        SlideRightRoute(
                          page: PackageList(),
                        ),
                      );
                      // Navigator.pop(context, false);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return ExitAppDialogWidget(
              title: 'Exit Counselinks',
              descriptions: 'Do you want to exit the app ?',
              yes: "Yes",
              no: "No",
            );
          },
        ) ??
        false;
  }
}
