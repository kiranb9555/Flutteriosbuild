import 'dart:convert';

import 'package:Counselinks/core/service_call.dart';
import 'package:Counselinks/core/util.dart';
import 'package:Counselinks/module/more.dart';
import 'package:Counselinks/module/transaction_detail.dart';
import 'package:Counselinks/shared/slide_left_route.dart';
import 'package:flutter/material.dart';

import '../core/constant.dart';
import '../database/shared_pred_data.dart';
import '../shared/slide_right_route.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  var userLoginResponse;
  dynamic userLoginData;
  var transactionList;
  bool isLoading = true;

  @override
  void initState() {
    _getAccountStatus();
    super.initState();
  }

  _getAccountStatus() async {
    try {
      userLoginResponse = (await SharedPrefData.getUserLoginData())!;
      setState(() {
        userLoginData = jsonDecode(userLoginResponse);
        String userId = userLoginData["responseObject"][0]['UserId'].toString();
        _getTransactionHistory(userId);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.transparent,
          appBar: Util().getAppBar(
            context,
            "Transaction History",
            Util().getScreenHeight(context),
            Util().getScreenHeight(context),
          ),
          body: _body(),
        ),
      ),
    );
  }

  _body() {
    double fontSize = Util().getScreenHeight(context);
    return Container(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: isLoading
          ? Util().loadIndicator()
          : transactionList.isNotEmpty
              ? _getTransactionList()
              : Center(
                  child: Util().getTextWithStyle1(
                    title: "Transaction List is Empty".toUpperCase(),
                    color: Colors.grey.shade900,
                    fontSize: fontSize * 0.02,
                    fontWeight: FontWeight.w700,
                  ),
                ),
    );
  }

  _getTransactionList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: transactionList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                SlideRightRoute(
                    page: TransactionDetail(
                        transactionList: transactionList, index: index)),
              );
              // Util().displayToastMsg("purchase package");
              // setState(() {
              //   isDownLoading = !isDownLoading;
              //   // _purchasePackageList(index);
              //   // isLoading = !isLoading;
              // });
            },
            title: _getCard(transactionList, index),
          );
        });
  }

  _getCard(transactionList, index) {
    double width = Util().getScreenHeight(context);
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
        padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
        height: height *0.07,
        width: width,
        color: Colors.white38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.payments_outlined,
                  color: Colors.green.shade800,
                  size: height * 0.025,
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Util().getTextWithStyle1(
                      title: transactionList[index]['PackageName'].toString() + " . " +transactionList[index]['PurchaseOn'].toString(),
                      color: Colors.blueGrey.shade800,
                      fontSize: fontSize * 0.021,
                      fontWeight: FontWeight.w500,
                    ),
                    Util().getTextWithStyle1(
                      title: "Amount : " +
                          Constant.rupee +
                          transactionList[index]['PaidAmount'].toString(),
                      color: Colors.green.shade800,
                      fontSize: fontSize * 0.021,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                )
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
    );
  }

  _getTransactionHistory(userId) {
    Map<String, dynamic> transactionHistoryMap = {
      "objRequestGetUserTransaction": {"UserId": int.parse(userId)}
    };

    print("transactionHistoryMap : $transactionHistoryMap");

    ServiceCall()
        .apiCall(
            context,
            Constant.API_BASE_URL + Constant.API_GET_TRANSACTION_DETAIL,
            transactionHistoryMap)
        .then((response) async {
      print("transactionHistory");
      print(response);
      if (response['responseCode'] == "1") {
        transactionList = response['responseObject'];
        setState(() {
          isLoading = !isLoading;
        });
      } else {
        Util().displayToastMsg(response['responseMessage']);
        setState(() {
          isLoading = !isLoading;
        });
      }
      // setState(() {
      //   userTransactionDetailId = response['responseObject']['UserTransactionDetailId'];
      // });
    });
  }
}
