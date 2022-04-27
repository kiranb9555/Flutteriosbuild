import 'package:Counselinks/module/chat_history.dart';
import 'package:Counselinks/module/home.dart';
import 'package:Counselinks/module/package_list.dart';
import 'package:Counselinks/module/transaction_detail.dart';
import 'package:Counselinks/module/transaction_history.dart';
import 'package:Counselinks/shell/exit_app_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../module/more.dart';
import '../module/profile.dart';
import '../shared/slide_left_route.dart';

class Util {
  getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  getTextWithStyle(
      {required String title,
      required Color color,
      required double fontSize,
      required FontWeight fontWeight}) {
    return Text(
      title,
      style: GoogleFonts.aBeeZee(
          color: color,
          letterSpacing: 0.2,
          fontSize: fontSize,
          fontWeight: fontWeight,
          textStyle: const TextStyle(
            decoration: TextDecoration.underline,
          )),
    );
  }

  getTextWithStyle1(
      {required String title,
      required Color color,
      required double fontSize,
      required FontWeight fontWeight}) {
    return Text(
      title,
      style: GoogleFonts.aBeeZee(
        color: color,
        letterSpacing: 0.2,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  getTextWithStyle2(
      {required String title,
      required Color color,
      required double fontSize,
      required FontWeight fontWeight}) {
    return Text(
      title,
      // maxLines: 3,
      style: GoogleFonts.aBeeZee(
        color: color,
        letterSpacing: 0.2,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  getAppBar(context, title, fontSize, height) {
    return AppBar(
      // backgroundColor: const Color(0xFF4bb0a9).withOpacity(0.1),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      // toolbarHeight: height * 0.1,
      title: Util().getTextWithStyle1(
        title: title,
        color: Colors.blueGrey.shade600,
        fontSize: fontSize * 0.028,
        fontWeight: FontWeight.bold,
      ),
      // centerTitle: true,
      leading: IconButton(
        iconSize: height * 0.028,
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.blueGrey.shade500,
        ),
        onPressed: () {
          if (title == "More" || title == "Chat") {
            Navigator.pushReplacement(
              context,
              SlideLeftRoute(
                page: Home(),
              ),
            );
          } else if (title == "Profile" ||
              title == "Chat History" ||
              title == "Transaction History" ||
              title == "Change Password") {
            Navigator.pushReplacement(
              context,
              SlideLeftRoute(
                page: More(),
              ),
            );
          } else if (title == "Chat Details") {
            Navigator.pushReplacement(
              context,
              SlideLeftRoute(
                page: ChatHistory(),
              ),
            );
          }else if (title == "Transaction Details") {
            Navigator.pushReplacement(
              context,
              SlideLeftRoute(
                page: TransactionHistory(),
              ),
            );
          } else if (title == "Update Profile") {
            Navigator.pushReplacement(
              context,
              SlideLeftRoute(
                page: Profile(),
              ),
            );
          } else if (title == "Order Summary") {
            Navigator.pushReplacement(
              context,
              SlideLeftRoute(
                page: PackageList(),
              ),
            );
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  getAppBar1(context, title, fontSize, height) {
    return AppBar(
      backgroundColor: const Color(0xFF4bb0a9).withOpacity(0.6),
      elevation: 0.0,
      // toolbarHeight: height * 0.1,
      title: Util().getTextWithStyle1(
        title: title,
        color: Colors.white,
        fontSize: fontSize * 0.028,
        fontWeight: FontWeight.w500,
      ),
      centerTitle: true,
      leading: Container(),
    );
  }

  boxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerRight,
        tileMode: TileMode.mirror,
        colors: [
          // const Color(0xFF91d0cc),
          // const Color(0xFF91d0cc),
          const Color(0xFF91d0cc).withOpacity(1.0),
          const Color(0xFF91d0cc).withOpacity(1.0),
          const Color(0xFF91d0cc).withOpacity(1.0),
          const Color(0xFF91d0cc).withOpacity(1.0),
          const Color(0xFF91d0cc).withOpacity(1.0),
          Colors.blueGrey.shade100,
          const Color(0xFF91d0cc),
          const Color(0xFF91d0cc),
          const Color(0xFF91d0cc).withOpacity(0.9),

          Colors.blueGrey.shade100,
          const Color(0xFF91d0cc).withOpacity(1.0),
          // Colors.blueGrey.shade100,
          Colors.blueGrey.shade100,
          // const Color(0xFF91d0cc),
          // const Color(0xFF91d0cc).withOpacity(0.4),
          // Colors.pink.shade100
        ],
      ),
    );
  }

  buttonStyle(
      {required Color foregroundColor,
      required Color backgroundColor,
      required Color borderColor,
      required double borderRadius}) {
    return ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(foregroundColor),
      // foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      // backgroundColor: MaterialStateProperty.all<Color>(Colors.pink.shade400),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          // borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: borderColor,
            // color: Colors.pink,
          ),
        ),
      ),
    );
  }

  displayToastMsg(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.yellow,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  loadIndicator() {
    return Container(
      color: Colors.white60.withOpacity(0.4),
      child: const Center(
        child: CircularProgressIndicator(
          backgroundColor: Color(0xFF91d0cc),
          color: Colors.deepOrange,
        ),
      ),
    );
  }

  getUnderConstruction(context) {
    double height = Util().getScreenHeight(context);
    double width = Util().getScreenWidth(context);
    return Image.asset(
      'assets/under_construction.jpg',
      height: height,
      width: width,
    );
  }

  inputDecoration(labelText, hintText, fontSize) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.blueGrey.shade800,
        fontSize: fontSize * 0.022,
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.blueGrey.shade600,
      ),
      filled: true,
      fillColor: Colors.blueGrey.shade50,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Colors.blueGrey.shade900),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Colors.blueGrey.shade900),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Colors.blueGrey.shade900),
      ),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: 1,
          )),
    );
  }

  validateField(value, labelText) {
    if (value != null && value.toString().isNotEmpty) {
      if (labelText == "Email") {
        var emailPattern =
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
        var match = RegExp(emailPattern, caseSensitive: false);
        if (match.hasMatch(value!)) {
          return null;
        } else {
          return 'Please enter valid email';
        }
      }
    } else {
      return 'Please enter $labelText';
    }
  }
}
