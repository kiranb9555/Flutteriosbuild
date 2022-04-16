import 'package:Counselinks/module/chat.dart';
import 'package:Counselinks/module/more.dart';
import 'package:Counselinks/module/signin.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../core/util.dart';
import '../database/shared_pred_data.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPage = 0;
  final _pageOptions = [Home(),  SignIn(),Chat(), More()];

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
    return Scaffold(

      body: _pageOptions[selectedPage],
      bottomNavigationBar: ConvexAppBar(
        items: [
          _checkLoginStatus(),
          TabItem(icon: Icons.chat_outlined, title: 'Chat'),
          TabItem(icon: Icons.more_horiz_outlined, title: 'More'),
        ],
        initialActiveIndex: isUserSaved ? 0 : 1,//optional, default as 0
        onTap: (int i ){
          if(isUserSaved){
            setState(() {
              selectedPage = 0;
            });
          }else {
            setState(() {
              selectedPage = 1;
            });
          }

          if (i == 2) {
            if(isUserSaved){
              setState(() {
                selectedPage = 2;
              });
            }else {
              Util().displayToastMsg("Please Sign in First ..");
              setState(() {
                selectedPage = 1;
              });
            }

          }
          if (i == 3) {
            setState(() {
              selectedPage = i;
            });
          }


        },
      )
    );
  }
  _checkLoginStatus(){
    return isUserSaved ? TabItem(icon: Icons.home_outlined, title: 'Home') : TabItem(title: 'Login', icon: Icons.login_outlined);
  }
}
