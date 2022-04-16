import 'package:Counselinks/module/chat_history.dart';
import 'package:Counselinks/module/more.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constant.dart';
import '../core/service_call.dart';
import '../core/util.dart';
import '../shared/slide_left_route.dart';

class ChatDetailHistory extends StatefulWidget {
  var chatQuestionList;
  String status ;
  String userChatId ;
  String userId ;

  ChatDetailHistory({
    required this.chatQuestionList,
    required this.status,
    required this.userChatId,
    required this.userId,
  });

  @override
  State<ChatDetailHistory> createState() => _ChatDetailHistoryState();
}

class _ChatDetailHistoryState extends State<ChatDetailHistory> {
  bool issShowing = false;
  TextEditingController txtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showTextBoxButton();
  }
  _showTextBoxButton(){
    if(widget.status =="5"){
      setState(() {
        issShowing = !issShowing;
      });
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
              page: ChatHistory(),
            ),
          );
          return false;
        },
        child: Scaffold(
          appBar: Util().getAppBar(context, "Chat Details", fontSize, height),
          backgroundColor: Colors.transparent,
          body: _body(),
        ),
      ),
    );
  }

  _body() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getChatList(context),
          issShowing ? _txtBoxButton() : Container()
        ],
      ),
    );
  }

  _getChatList(context) {
    return Container(
      child: Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.chatQuestionList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Card(
                    margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    color:  widget.chatQuestionList[index]['AnswerType'].toString() != "2" ? const Color(0xFF91d0cc) : Colors.white60,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 2.0,
                    child: _chatListWidget(
                        widget.chatQuestionList[index]['Answer'].toString(),
                        widget.chatQuestionList[index]['Question'].toString(),
                        widget.chatQuestionList[index]['AnswerTypeName'].toString(),
                        widget.chatQuestionList[index]['AnswerType'].toString(),
                        index)),
              );
            }),
      ),
    );
    /*
    * {CanRply: 0, ChatCode: Out-011, ChatName: 15-03-2022, ChatQuestionList:
    * */
  }

  _chatListWidget(answer, question, answerTypeName,answerType, index) {
    double height = Util().getScreenHeight(context);
    double width = Util().getScreenWidth(context);
    return Container(
      // height: height * 0.15,
      // width: width,
      child: AspectRatio(
        aspectRatio: 35.0 / 8.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10.0, top: 5.0),
              height: height * 0.13,
              width: width * 0.92,
              color: Colors.white60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Util().getTextWithStyle1(
                      title: answerTypeName.toString(),
                      color: answerType == "2" ? Colors.blue.shade900 :Colors.blue.shade600,
                      fontSize: height * 0.022,
                      fontWeight: FontWeight.bold),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      itemsRows("question", question, answerType),
                      itemsRows("answer", answer, answerType),
                    ],
                  ),
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

  itemsRows(label, value, AnswerType) {
    double fontSize = Util().getScreenHeight(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Util().getTextWithStyle1(
            title: "$label : ",
            color: Colors.blueGrey.shade700,
            fontSize: fontSize * 0.02,
            fontWeight: FontWeight.w200),
        Util().getTextWithStyle1(
          title: value.toString(),
          color: Colors.blueGrey.shade800,
          fontSize: fontSize * 0.022,
          fontWeight: FontWeight.w200,
        )
      ],
    );
  }

  _txtBoxButton(){
      return Container(
        margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _chatBox(),
            _sendButton()
          ],
        ),
      );
  }

  _chatBox() {
    double fontSize = Util().getScreenHeight(context);
    double width = Util().getScreenWidth(context)*0.75;
    return Container(
      width: width,
      child: TextField(
        maxLines: 2,
        controller: txtController,
        cursorColor: Colors.blueGrey.shade900,
        cursorHeight: 20.0,
        style: TextStyle(
          color: Colors.blueGrey.shade600,
          fontSize: fontSize * 0.022,
        ),
        decoration: InputDecoration(

          filled: true,
          fillColor: Colors.blueGrey.shade50,

          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(
                width: 1,
              )),
        ),
      ),
    );
  }

  _sendButton() {
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: const Icon(Icons.send , color: Colors.blueGrey, size: 50.0,),
      style: Util().buttonStyle(
          foregroundColor: const Color(0xFF91d0cc).withOpacity(0.9),
          backgroundColor: const Color(0xFF91d0cc).withOpacity(0.9),
          borderColor: const Color(0xFF91d0cc).withOpacity(0.9),
          borderRadius: 8.0),
      onPressed: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        if(txtController.text.trim().isNotEmpty){
          _sendChat();
        }else{
          Util().displayToastMsg("Type Something ...");
        }
      },
    );
  }

  _sendChat() async {
    Map<String, dynamic> chatResponseMap = {
      "objRequestReplyQueryChatDetail":{
        "UserChatDetailId":"0",
        "Answer": txtController.text.trim(),
        "UserChatId": widget.userChatId,
        "UserId":widget.userId
      }
    };

    print("chatMap");
    print(chatResponseMap);
    ServiceCall()
        .apiCall(
        context, Constant.API_BASE_URL + Constant.API_REPLY_BY_USER, chatResponseMap)
        .then((response) async {
      if (response["responseCode"] == "1") {
        Util().displayToastMsg(response["responseMessage"]);
        setState(() {
          issShowing = !issShowing;
        });
        // setState(() {
        //   chatResponse = response;
        //   print("chatResponse");
        //   print(chatResponse);
        //   setState(() {
        //     isSearchingData = !isSearchingData;
        //   });
        // });
      } else if (response["responseCode"] == "0") {
        Util().displayToastMsg(response["responseMessage"]);
        // setState(() {
        //   isSearchingData = !isSearchingData;
        // });
      }
    });
  }
}
