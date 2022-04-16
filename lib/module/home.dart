import 'dart:convert';

import 'package:Counselinks/core/constant.dart';
import 'package:Counselinks/database/shared_pred_data.dart';
import 'package:Counselinks/module/profile.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../core/util.dart';
import '../notificationservice/local_notification_service.dart';
import '../shared/bottom_navigation_widget.dart';
import '../shared/slide_right_route.dart';
import '../shared/webPage.dart';
import '../shell/exit_app_dialog_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String deviceTokenToSendPushNotification = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late WebViewController _controller;
  late String tcc;
  var userLoginResponse;
  dynamic userLoginData;
  var htmlData;

  bool isLoggedIn = false;
  bool shouldPop = false;

  @override
  void initState() {
    setState(() {
      _getAccountStatus();
    });
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  _getAccountStatus() async {
    try {
      userLoginResponse = (await SharedPrefData.getUserLoginData())!;
      setState(() {
        userLoginData = jsonDecode(userLoginResponse);
      });
      if (await SharedPrefData.getUserLoggedIn() != null) {
        if (await SharedPrefData.getTcAccepted() == null) {
          getTC();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  getTC() async {
    // String? tc = await SharedPrefData.getTermCondition();
    _displayDialog(_scaffoldKey);
    setState(() {
      // tcc = tc!;
      try {
        htmlData =
            """<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>${userLoginData['responseObject'][0]['TermCondition']}</html>""";
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        decoration: Util().boxDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          bottomNavigationBar: BottomNavigationWidget(0),
          body: _body(),
        ),
      ),
    );
  }

  _body() {
    return Container(
      child: WebPage(Constant.WEBSITE_LINK.toString()),
    );
  }

  _checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
    } else {
      Util().displayToastMsg("Check Internet Conenction.");
    }
  }

  _loadHtmlFromAssets() async {
    _controller.loadUrl(Uri.dataFromString(htmlData,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  _displayDialog(_scaffoldKey) {
    double height = Util().getScreenHeight(context);
    double fontSize = Util().getScreenHeight(context);
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 500),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.1,
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 40.0, bottom: 60.0),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Util().getAppBar1(
                          context, "Terms & Conditions", fontSize, height),
                      Container(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: WebView(
                          initialUrl: 'about:blank',
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            _controller = webViewController;
                            _loadHtmlFromAssets();
                          },
                          onPageStarted: (value) {
                            setState(() {});
                          },
                          onPageFinished: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      Center(
                        child: _acceptTC(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _acceptTC() {
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: Util().getTextWithStyle1(
          title: "Accept Terms & Conditions >>".toUpperCase(),
          color: Colors.grey.shade900,
          fontSize: fontSize * 0.02,
          fontWeight: FontWeight.w700),
      style: Util().buttonStyle(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF91d0cc).withOpacity(0.9),
          borderColor: const Color(0xFF91d0cc).withOpacity(0.7),
          borderRadius: 18.0),
      onPressed: () async {
        SharedPrefData.setTcAccepted(false);
        Navigator.pop(context);
        // String email = await SharedPrefData.getUserEmail();
        // if (_formKey.currentState!.validate()) {
        //   setState(() {
        //     isSavingData = !isSavingData;
        //   });
        //
        //   print(emailController.text + "  "+ passwordController.text);
        //
        //   _loginUser(1, passwordController.text, emailController.text);
        // }
      },
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
