import 'package:Counselinks/module/package_list.dart';
import 'package:Counselinks/module/status.dart';
import 'package:Counselinks/shell/package_order_summary.dart';
import 'package:Counselinks/shell/razor_pay_page.dart';
import 'package:flutter/material.dart';

import '../core/util.dart';
import '../database/shared_pred_data.dart';
import '../shared/bottom_navigation_widget.dart';
import '../shared/slide_left_route.dart';
import '../shared/slide_right_route.dart';
import '../shell/exit_app_dialog_widget.dart';
import 'change_password.dart';
import 'chat.dart';
import 'chat_history.dart';
import 'home.dart';
import 'home.dart';
import 'profile.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  bool isLoading = false;
  bool isLoggedIn = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    setState(() {
      _getAccountStatus();
    });
    super.initState();
  }

  _getAccountStatus() async {
    try {
      isLoggedIn = (await SharedPrefData.getUserLoggedIn())!;
      setState(() {
        _isLoggedIn = isLoggedIn;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = Util().getScreenHeight(context);
    double fontSize = Util().getScreenHeight(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          SlideLeftRoute(
            page: Home(),
          ),
        );
        return false;
      },
      child: Container(
        decoration: Util().boxDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: BottomNavigationWidget(2),
          appBar: Util().getAppBar(context, "More", fontSize, height),
          body: _body(height, fontSize),
        ),
      ),
    );
  }

  _body(height, fontSize) {
    return Container(
      height: height,
      // decoration: Util().boxDecoration(),
      // color: const Color(0xFF4bb0a9).withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : _getItemList(),
    );
  }

  _getItemList() {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getCard(icon: Icons.home_outlined, title: "Home"),
          const SizedBox(
            height: 5.0,
          ),
          _isLoggedIn != null
              ? _isLoggedIn
                  ? _getCard(
                      icon: Icons.account_circle_outlined, title: "Profile")
                  : Container()
              : Container(),
          const SizedBox(
            height: 5.0,
          ),
          _isLoggedIn != null
              ? _isLoggedIn
                  ? _getCard(
                      icon: Icons.sell_outlined, title: "Purchase Package")
                  : Container()
              : Container(),
          const SizedBox(
            height: 5.0,
          ),
          _isLoggedIn != null
              ? _isLoggedIn
                  ? _getCard(
                      icon: Icons.local_activity_outlined, title: "Status")
                  : Container()
              : Container(),
          const SizedBox(
            height: 5.0,
          ),
          _isLoggedIn != null
              ? _isLoggedIn
                  ? _getCard(
                      icon: Icons.history_outlined, title: "Chat History")
                  : Container()
              : Container(),
          const SizedBox(
            height: 5.0,
          ),
          _isLoggedIn != null
              ? _isLoggedIn
                  ? _getCard(
                      icon: Icons.password_outlined, title: "Change Password")
                  : Container()
              : Container(),
          // const SizedBox(
          //   height: 5.0,
          // ),
          // _getCard(icon: Icons.rate_review_outlined, title: "Rate Us"),
          // const SizedBox(
          //   height: 5.0,
          // ),
          // _getCard(icon: Icons.share, title: "Share"),
          // const SizedBox(
          //   height: 5.0,
          // ),
          // _getCard(icon: Icons.update, title: "Check Update"),
          const SizedBox(
            height: 5.0,
          ),
          _isLoggedIn != null
              ? _isLoggedIn
                  ? _getCard(icon: Icons.logout, title: "Logout")
                  : Container()
              : Container(),
        ],
      ),
    );
  }

  _getCard({
    required IconData icon,
    required String title,
  }) {
    double width = Util().getScreenHeight(context);
    double height = Util().getScreenHeight(context);
    double fontSize = Util().getScreenHeight(context);
    return GestureDetector(
      onTap: () => _pageHandler(title),
      child: Card(
        margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
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
                  Icon(
                    icon,
                    color: Colors.blueGrey.shade800,
                    size: height * 0.025,
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Util().getTextWithStyle1(
                      title: title,
                      color: Colors.blueGrey.shade800,
                      fontSize: fontSize * 0.021,
                      fontWeight: FontWeight.w500),
                  // Text(
                  //   "Promote your blogs/website",
                  //   style: GoogleFonts.aBeeZee(
                  //     color: Colors.blueGrey.shade800,
                  //     letterSpacing: 0.2,
                  //     fontSize: 18.0,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
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
    );
  }

  _pageHandler(title){
    if (title == "Home") {
      Navigator.pushReplacement(context, SlideRightRoute(page: Home()));
    } else if (title == "Profile") {
      Navigator.pushReplacement(context, SlideRightRoute(page: Profile()));
    } else if (title == "Purchase Package") {
      Navigator.pushReplacement(
          context, SlideRightRoute(page: PackageList()));
    } else if (title == "Status") {
      Navigator.pushReplacement(context, SlideRightRoute(page: Status()));
    } else if (title == "Chat History") {
      Navigator.pushReplacement(
          context, SlideRightRoute(page: ChatHistory()));
    } else if (title == "Change Password") {
      Navigator.pushReplacement(
          context, SlideRightRoute(page: ChangePassword()));
    } else if (title == "Rate Us") {
      Util().displayToastMsg("Under Development");
      // Navigator.pushReplacement(context, SlideRightRoute(page : Home()));
    } else if (title == "Share") {
      // Navigator.pushReplacement(
      //   context,
      //   SlideLeftRoute(
      //     page: RazorpayPage(),
      //   ),
      // );
      Util().displayToastMsg("Under Development");
      // Navigator.pushReplacement(context, SlideRightRoute(page : Home()));
    } else if (title == "Check Update") {
      Util().displayToastMsg("Under Development");
      // Navigator.pushReplacement(context, SlideRightRoute(page : Home()));
    } else if (title == "Logout") {
      return _logout();
      // Navigator.pushReplacement(context, SlideRightRoute(page : Home()));
    }

    // else if (title == "Check Update") {
    //   return _launchPlayStore();
    // } else if (title == "Logout") {
    //   return _logout();
    // }
  }

  _logout() async {
    setState(() {
      isLoading = !isLoading;
    });
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
      isLoading = !isLoading;
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
