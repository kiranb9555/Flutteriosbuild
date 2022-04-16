
import 'package:Counselinks/module/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../core/util.dart';
import '../database/shared_pred_data.dart';
import '../module/chat.dart';
import '../module/home.dart';
import '../module/more.dart';
import 'slide_zero_route.dart';

class BottomNavigationWidget extends StatefulWidget {
  final int initialIndex;

  BottomNavigationWidget(this.initialIndex);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  bool isUserSaved = false;

  @override
  void initState() {
    setState(() {
      _getUserData();
    });
    super.initState();
  }

  _getUserData() async {
    bool? _isSaved = await SharedPrefData.getUserLoggedIn();

    if(_isSaved != null){
      if (_isSaved) {
        setState(() {
          isUserSaved = !isUserSaved;
        });
      }
    }else{
      isUserSaved = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = Util().getScreenHeight(context);

    // return ConvexAppBar.badge({0: '99+', 1: Icons.assistant_photo, 2: Colors.redAccent},
    //     items: [
    //     TabItem(icon: Icons.home, title: 'Home'),
    // TabItem(icon: Icons.map, title: 'Discovery'),
    // TabItem(icon: Icons.add, title: 'Add'),
    // ],
    // onTap: (int i) => print('click index=$i'),);

    return ConvexAppBar(
      height: height * 0.064,
      // height: 40.0,
      curveSize: height * 0.1,
      activeColor: Colors.blueGrey.shade700,
      backgroundColor: const Color(0xFF91d0cc),
      color: Colors.blueGrey.shade800,
      elevation: 0.0,
      items:  [
        _checkLoginStatus(),
        // TabItem(icon: Icons.home_outlined, title: 'Home'),
        TabItem(icon: Icons.chat_outlined, title: 'Chat'),
        TabItem(icon: Icons.more_horiz_outlined, title: 'More'),
      ],
      initialActiveIndex: widget.initialIndex,
      //optional, default as 0
      onTap: (int i) {
        if (i == 0) {
          if(isUserSaved){
            Navigator.push(
              context,
              SlideZeroRoute(
                page: Home(),
              ),
            );
          }else {
            Navigator.push(
              context,
              SlideZeroRoute(
                page: SignIn(),
              ),
            );
          }

        }
        // else if (i == 1) {
        //   Navigator.push(
        //     context,
        //     SlideZeroRoute(
        //       page: Home(),
        //     ),
        //   );
        // }

        else if (i == 1) {
          if(isUserSaved){
            Navigator.push(
              context,
              SlideZeroRoute(
                page: Chat(),
              ),
            );
          }else {
            Util().displayToastMsg("Please Sign in First ..");
            Navigator.push(
              context,
              SlideZeroRoute(
                page: SignIn(),
              ),
            );
          }

        } else if (i == 2) {
          Navigator.push(
            context,
            SlideZeroRoute(
              page: More(),
            ),
          );
        }
        // else if (i == 3) {
        //   if (isUserSaved) {
        //     Navigator.push(
        //       context,
        //       SlideZeroRoute(
        //         page: Profile(),
        //       ),
        //     );
        //   } else {
        //     Navigator.push(
        //       context,
        //       SlideZeroRoute(
        //         page: LoginPage(),
        //       ),
        //     );
        //   }
        // }
      },
    );
  }

  _checkLoginStatus(){
     return isUserSaved ? TabItem(icon: Icons.home_outlined, title: 'Home') : TabItem(title: 'Login', icon: Icons.login_outlined);
  }
}
