import 'dart:convert';

import 'package:Counselinks/database/shared_pred_data.dart';
import 'package:Counselinks/module/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../core/constant.dart';
import '../core/service_call.dart';
import '../core/util.dart';
import '../shared/slide_right_route.dart';
import '../shell/package_order_summary.dart';

class PackageList extends StatefulWidget {

  const PackageList({
    Key? key
  }) : super(key: key);

  @override
  State<PackageList> createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {
  bool isLoading = true;
  bool isDownLoading = false;
  dynamic _response;
  bool valueFirst = false;
  bool valueSecond = false;
  final int PackageMasterId = 0;
  final int amount = 0;
  var userLoginResponse;
  dynamic userLoginData;
  int userId = 0;

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
        userId = userLoginData["responseObject"][0]['UserId'];
        _getPackageList();
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
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: Util().getAppBar(context, "Package List", fontSize, height),
          body: Stack(
            children: [
              _body(height),
              isDownLoading ? Util().loadIndicator() : Container(),
            ],
          )),
    );
  }

  _body(height) {
    return Container(
      height: height,
      child: isLoading
          ? Container(
              color: Colors.white.withOpacity(0.2),
              child: Util().loadIndicator(),
            )
          : _getPackageListWidget(context),
    );
  }

  _getPackageListWidget(context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _response['responseObject'].length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              Navigator.pushReplacement(
              context,
              SlideRightRoute(page: PackageOrderSummary(
                packageName: _response['responseObject'][index]['PackageName']
                    .toString(),
                amount: _response['responseObject'][index]['Amount'].toString(),
                discount: _response['responseObject'][index]['Discount'].toString(),
                  packageMasterId: _response['responseObject'][index]
                  ['PackageMasterId'].toString()

              )),
            );
              Util().displayToastMsg("purchase package");
              // setState(() {
              //   isDownLoading = !isDownLoading;
              //   // _purchasePackageList(index);
              //   // isLoading = !isLoading;
              // });
            },
            title: Card(
                margin: const EdgeInsets.only(top: 5.0),
                color: const Color(0xFF91d0cc),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 2.0,
                child: _packageListWidget(
                    _response['responseObject'][index]['PackageName']
                        .toString(),
                    _response['responseObject'][index]['Amount'].toString(),
                    _response['responseObject'][index]['NoOfChat'].toString(),
                    _response['responseObject'][index]['PackageDetail']
                        .toString(),
                    _response['responseObject'][index]['Discount'].toString(),
                    _response['responseObject'][index]['ValidDays'].toString(),
                    index)),
          );
        });
  }

  _packageListWidget(
      packageName, amount, chats, packageDetail, discount, validDays, index) {
    double height = Util().getScreenHeight(context);
    double width = Util().getScreenWidth(context);
    return Container(
      height: height * 0.13,
      width: width,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Util().getTextWithStyle1(
                    title: packageName.toString(),
                    color: Colors.red.shade600,
                    fontSize: height * 0.022,
                    fontWeight: FontWeight.bold),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        itemsRows("Amount", amount),
                        itemsRows("Chats", chats),
                        itemsRows("Detail", packageDetail),
                      ],
                    ),
                    SizedBox(
                      width: width * 0.18,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        itemsRows("Discount", discount),
                        itemsRows("Validity", validDays),
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
    );
  }

  // _checkBox(index) {
  //   return
  //       //   CheckboxListTile(
  //       //     activeColor: Colors.pink[300],
  //       //     dense: true,
  //       //     //font change
  //       //     value: checkBoxListTileModel[index].isCheck,
  //       //
  //       //     onChanged: (val) {
  //       //   itemChange(val, index);
  //       // });
  //       Checkbox(
  //     checkColor: Colors.teal,
  //     activeColor: Colors.white,
  //     value: this.valueFirst,
  //     onChanged: (value) {
  //       print("checkbox13");
  //       print(value);
  //       setState(() {
  //         this.valueFirst = value!;
  //         setState(() {
  //           _purchasePackageList(index);
  //           // isLoading = !isLoading;
  //         });
  //       });
  //     },
  //   );
  // }

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

  _getPackageList() {
    Map<String, dynamic> purchaseMap = {
      "objRequestPackageMaster": {
        "Action": "GETFORNEWPACKAGE",
        // "UserId": "1"
        //TODO :Change UserId
        "UserId": userId
      }
    };

    print("purchaseMap");
    print(purchaseMap);

    ServiceCall()
        .apiCall(
            context,
            Constant.API_BASE_URL + Constant.API_PACKAGE_DETAIL_LIST,
            purchaseMap)
        .then((response) {
      if (response["responseCode"] == "1") {
        setState(() {
          _response = response;
          isLoading = !isLoading;
        });
      }
    });
  }

  _purchasePackageList(index) {
    Map<String, dynamic> purchaseMap1 = {
      "objRequestPackageMaster": {
        "PackageMasterId": _response['responseObject'][index]
            ['PackageMasterId'],
        "UserId": userId,
        "Amount": _response['responseObject'][index]['Amount']
      }
    };

    ServiceCall()
        .apiCall(
            context,
            Constant.API_BASE_URL + Constant.API_PURCHASE_PACKAGE_LIST,
            purchaseMap1)
        .then((response) {
      if (response["responseCode"] == "1") {
        setState(() {
          Util().displayToastMsg(response["responseMessage"].toString());
          isDownLoading = !isDownLoading;
          _alertDialogWidget();
        });
      } else {
        setState(() {
          isDownLoading = !isDownLoading;
        });
        Util().displayToastMsg(response["responseMessage"].toString());
      }
    });
  }

  _alertDialogWidget() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: _openDialog(
            context,
            'Success !!!',
            'Package purchased successfully !',
            "ok",
          ),
        );
      },
    );
  }

  _openDialog(context, title, description, purchase) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constant.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, title, description, purchase),
    );
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
                      SharedPrefData.setPackagesPurchaseData(true);
                      Navigator.pushReplacement(
                        context,
                        SlideRightRoute(page: Home()),
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
}
