import 'dart:convert';

import 'package:Counselinks/module/chat_detail_history.dart';
import 'package:Counselinks/shared/slide_left_route.dart';
import 'package:Counselinks/shared/slide_right_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constant.dart';
import '../core/service_call.dart';
import '../core/util.dart';
import '../database/shared_pred_data.dart';
import 'more.dart';
import 'package:intl/intl.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({Key? key}) : super(key: key);

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  var chatResponse;
  var userLoginResponse;
  dynamic userLoginData;
  bool isSearchingData = false;

  @override
  void initState() {
    // _getChatHistory();
    _getFilledData();
    super.initState();
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  _getFilledData() async {
    fromDateController.text =
        (formatter.format(DateTime.now().subtract(Duration(days: 30))))
            .toString();
    toDateController.text = (formatter.format(DateTime.now())).toString();

    try {
      userLoginResponse = (await SharedPrefData.getUserLoginData())!;
      setState(() {
        userLoginData = jsonDecode(userLoginResponse);
        setState(() {
          isSearchingData = !isSearchingData;
        });
        _getChatHistory();
        // print("IsProfileUpdated13435");
        // print(userLoginData['responseObject'][0]['AppAccessTypeId']);
        // print(userLoginData['responseObject'][0]['UserId']);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = Util().getScreenHeight(context);
    double fontSize = Util().getScreenHeight(context);
    return Container(
      decoration: Util().boxDecoration(),
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            SlideLeftRoute(
              page: More(),
            ),
          );
          return false;
        },
        child: Scaffold(
          appBar: Util().getAppBar(context, "Chat History", fontSize, height),
          backgroundColor: Colors.transparent,
          body: _body(),
        ),
      ),
    );
  }

  _body() {
    double width = Util().getScreenHeight(context) * 0.15;
    return Stack(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              alignment: Alignment.topCenter,
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _detailForm("Enter Date From...", "From", width,
                        fromDateController),
                    _detailForm(
                        "Enter Date To...", "To", width, toDateController),
                    _searchButton()
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            chatResponse != null ? chatResponse['responseObject'].isNotEmpty ? _getChatList(context) : Util().getTextWithStyle1(
                title: "No Chat History Found",
                color: Colors.blueGrey.shade700,
                fontSize: Util().getScreenHeight(context) * 0.02,
                fontWeight: FontWeight.w500,
            ) : Container()
          ],
        ),
        isSearchingData ? Util().loadIndicator() : Container(),
      ],
      // child: Text(chatResponse != null ? chatResponse['responseObject'].toString() : ""),
      // child: Text(chatResponse != null ? chatResponse['responseObject'].toString() : ""),
    );
  }

  _detailForm(String hintText, String labelText, double width,
      TextEditingController controller) {
    double fontSize = Util().getScreenHeight(context);
    return Container(
      width: width,
      child: TextFormField(
        keyboardType: TextInputType.none,
        onTap: () {
          _clearFilledData(labelText);
          _callApi(labelText);
        },
        validator: (value) {
          if (value == "") {
            return 'Please enter $labelText';
          }
          return null;
        },
        controller: controller,
        cursorColor: Colors.blueGrey.shade900,
        cursorHeight: 20.0,
        showCursor: false,
        readOnly: false,
        style: TextStyle(
          color: Colors.blueGrey.shade600,
          fontSize: fontSize * 0.022,
        ),
        decoration: Util().inputDecoration(labelText, hintText, fontSize),
      ),
    );
  }

  _callApi(labelText) {
    if (labelText == "From") {
      print("call From API");
      _selectFromDate(context);
    } else if (labelText == "To") {
      print("call From API");
      _selectToDate(context);
    }
    setState(() {
      // dobController.text = '1244';
    });
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1947, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        final String formatted = formatter.format(selectedDate);
        fromDateController.text = formatted.toString();
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1947, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        final String formatted = formatter.format(selectedDate);
        toDateController.text = formatted.toString();
      });
    }
  }

  _clearFilledData(labelText) {
    if (labelText == "From" && fromDateController.text.isNotEmpty) {
      return fromDateController.clear();
    } else if (labelText == "To" && toDateController.text.isNotEmpty) {
      return toDateController.clear();
    }
  }

  _searchButton() {
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: Util().getTextWithStyle1(
          title: "Search".toUpperCase(),
          color: Colors.black,
          fontSize: fontSize * 0.02,
          fontWeight: FontWeight.w700),
      style: Util().buttonStyle(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF91d0cc).withOpacity(0.9),
        borderColor: const Color(0xFF91d0cc).withOpacity(0.7),
        borderRadius: 18.0,
      ),
      onPressed: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        // String email = await SharedPrefData.getUserEmail();
        // Navigator.pushReplacement(
        //   context,
        //   SlideRightRoute(
        //     page: OtpVerification("1"),
        //   ),
        // );
        if (_formKey.currentState!.validate()) {
          setState(() {
            isSearchingData = !isSearchingData;
          });

          _getChatHistory();
        }
      },
    );
  }

  _getChatHistory() async {
    Map<String, dynamic> chatMap = {
      "objRequestMyChat": {
        // Todo : change user id, right now it is hard coded.
        "UserId": userLoginData['responseObject'][0]['UserId'],
        // "UserId": userLoginData['responseObject'][0]['UserId'],
        "AppAccessTypeId":
            userLoginData['responseObject'][0]['AppAccessTypeId'].toString(),
        "FromDate": fromDateController.text,
        "ToDate": toDateController.text
      }
    };

    print("chatMap");
    print(chatMap);
    ServiceCall()
        .apiCall(
            context, Constant.API_BASE_URL + Constant.API_GET_ALL_CHAT, chatMap)
        .then((response) async {
      if (response["responseCode"] == "1") {
        setState(() {
          chatResponse = response;
          print("chatResponse");
          print(chatResponse);
          setState(() {
            isSearchingData = !isSearchingData;
          });
        });
      } else if (response["responseCode"] == "0") {
        Util().displayToastMsg(response["responseMessage"]);
        setState(() {
          isSearchingData = !isSearchingData;
        });
      }
    });
  }

  _getChatList(context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: chatResponse['responseObject'].length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              setState(() {
                Navigator.pushReplacement(
                  context,
                  SlideRightRoute(
                    page: ChatDetailHistory(
                      chatQuestionList: chatResponse['responseObject'][index]
                          ['ChatQuestionList'],
                      status : chatResponse['responseObject'][index]['Status'].toString(),
                      userChatId : chatResponse['responseObject'][index]['UserChatId'].toString(),
                      userId : userLoginData['responseObject'][0]['UserId'].toString(),
                    ),
                  ),
                );
                // isDownLoading = !isDownLoading;
                // _purchasePackageList(index);
                // isLoading = !isLoading;
              });
            },
            title: Card(
                margin: const EdgeInsets.only(top: 5.0),
                color: const Color(0xFF91d0cc),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 2.0,
                child: _chatListWidget(
                    chatResponse['responseObject'][index]['ChatName']
                        .toString(),
                    chatResponse['responseObject'][index]['StatusName'].toString(),
                    chatResponse['responseObject'][index]['GroupName']
                        .toString(),
                    chatResponse['responseObject'][index]['ChatQuestionList'],
                    index)),
          );
        });
    /*
    * {CanRply: 0, ChatCode: Out-011, ChatName: 15-03-2022, ChatQuestionList:
    * */
  }

  _chatListWidget(ChatName, StatusName, GroupName, ChatQuestionList, index) {
    double height = Util().getScreenHeight(context);
    double width = Util().getScreenWidth(context);
    return Container(
      // height: height * 0.13,
      // width: width,
      child: AspectRatio(
        aspectRatio: 35.0 / 8.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10.0, top: 5.0,right: 10.0),
              height: height * 0.13,
              width: width * 0.92,
              color: Colors.white60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Util().getTextWithStyle1(
                      title: ChatName.toString(),
                      color: Colors.red.shade600,
                      fontSize: height * 0.022,
                      fontWeight: FontWeight.bold),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          itemsRows("Chat", GroupName),
                          itemsRows("Status", StatusName),
                          // itemsRows("Detail", packageDetail),
                        ],
                      ),
                      SizedBox(
                        width: width * 0.18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blueGrey.shade800,
                            size: height * 0.02,
                          ),
                          // itemsRows("Discount", discount),
                          // itemsRows("Validity", validDays),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            // Container(
            //   width: width * 0.09,
            //   // color: Colors.red.shade500,
            //   child: Center(
            //     child: _checkBox(index),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  itemsRows(label, value) {
    double fontSize = Util().getScreenHeight(context);
    return Row(
      children: [
        Util().getTextWithStyle1(
            title: "$label : ",
            color: Colors.blueGrey.shade700,
            fontSize: fontSize * 0.02,
            fontWeight: FontWeight.w200),
        Util().getTextWithStyle1(
            title: value.toString(),
            color: Colors.blueGrey.shade800,
            fontSize: fontSize * 0.021,
            fontWeight: FontWeight.w200)
      ],
    );
  }
}
