import 'dart:convert';

import 'package:Counselinks/core/util.dart';
import 'package:Counselinks/module/home.dart';
import 'package:Counselinks/module/package_list.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../core/constant.dart';
import '../core/service_call.dart';
import '../database/shared_pred_data.dart';
import '../model/user_login_response.dart';
import '../shared/slide_left_route.dart';
import '../shared/slide_right_route.dart';

class PackageOrderSummary extends StatefulWidget {
  final String packageName;
  final String amount;
  final String discount;
  final String packageMasterId;

  const PackageOrderSummary(
      {Key? key,
      required this.packageName,
      required this.amount,
      required this.discount,
      required this.packageMasterId,
      })
      : super(key: key);

  @override
  State<PackageOrderSummary> createState() => _PackageOrderSummaryState();
}

class _PackageOrderSummaryState extends State<PackageOrderSummary> {
  TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPaymentSuccess = false;
  bool isLoading = false;
  var _razorpay = Razorpay();
  var userLoginResponse;
  dynamic userLoginData;
  String userTransactionDetailId = "";
  String machineId = "";
  String userEmail = "";
  String userPassword = "";
  String customerId = "";
  String orderId = "";
  String paymentId = "";
  String transactionId = "";
  String paymentType = "";
  String paymentTypeDetail = "";
  String receiptId = "";
  String remarks = "";

  @override
  void initState() {
    _getUserDetail();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  _getUserDetail() async {
    try {
      userLoginResponse = (await SharedPrefData.getUserLoginData())!;
      machineId = (await SharedPrefData.getMachineID())!;
      userEmail  = (await SharedPrefData.getUserEmail())!;
      userPassword  = (await SharedPrefData.getUserPassword())!;

      setState(() {
        userLoginData = jsonDecode(userLoginResponse);
        // machineId = _machineId;
        // userEmail = email;
        // userPassword = password;
        // print("4444");
        // print(machineId);
        // print(userEmail);
        // print(userPassword);
        print(userLoginResponse);
      });
    } catch (e) {
      print(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("paymentsuccess5555");
    print(response.orderId);
    print(response.signature);
    print(response.paymentId);
    setState(() {
      orderId = response.orderId.toString();
      paymentId = response.paymentId.toString();
      // _paymentsDetails(paymentId);
    });
    _capturePayments(response.paymentId);
    Util().displayToastMsg("Payment Successful");

    // _purchasePackageList(response.orderId, response.paymentId);

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("paymentfailed666");
    print(response.message);
    print(response.code);
    Util().displayToastMsg("Payment failed");
    // _finalSaveTransactionDetails();
    setState(() {
      isLoading = !isLoading;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
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
              page: PackageList(),
            ),
          );
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: Util().getAppBar(context, "Order Summary",
              Util().getScreenHeight(context), Util().getScreenHeight(context)),
          body: _body(),
        ),
      ),
    );
  }

  _body() {
    double height = Util().getScreenHeight(context);
    double fontSize = Util().getScreenHeight(context);
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 50.0,
              ),
              Card(
                margin: const EdgeInsets.only( top: 10.0,),
                color: const Color(0xFF91d0cc).withOpacity(1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 1.0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  height: height * 0.2,
                  width: Util().getScreenHeight(context),
                  color: Colors.white38,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      itemsRows("Package Name", widget.packageName),
                      itemsRows("Amount", widget.amount),
                      itemsRows("Discount", widget.discount),
                      itemsRows("Total",
                          int.parse(widget.amount) - int.parse(widget.discount)),

                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              _payButton()
            ],
          ),
        ),
        isLoading ? Util().loadIndicator() : Container(),
      ],
    );

  }

  itemsRows(label, value) {
    double fontSize = Util().getScreenHeight(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Util().getTextWithStyle1(
            title: "$label : ",
            color: Colors.blueGrey.shade600,
            fontSize: fontSize * 0.03,
            fontWeight: FontWeight.w200),
        Util().getTextWithStyle1(
            title: (label == "Package Name")
                ? value.toString()
                : "₹ " + value.toString(),
            color: Colors.blueGrey.shade800,
            fontSize: fontSize * 0.03,
            fontWeight: FontWeight.w200)
      ],
    );
  }

  _payButton() {
    int total = int.parse(widget.amount) - int.parse(widget.discount);
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: Container(
        height: Util().getScreenHeight(context) * 0.06,
        alignment: Alignment.center,
        width: Util().getScreenWidth(context),
        child: Util().getTextWithStyle1(
          title: "Purchase".toUpperCase(),
          color: Colors.white60,
          fontSize: fontSize * 0.03,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: Util().buttonStyle(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        borderColor: Colors.teal,
        borderRadius: 18.0,
      ),
      onPressed: () async {
        // _alertDialogWidget("order_bsdchfbcsdb", "payment_bsdchfbcsdb");
        if(total != 0){
          setState(() {
            isLoading = !isLoading;
          });
          _saveTransactionDetails();


        }else{
          _purchasePackageList("", "");
          // Util().displayToastMsg("Zero amount");
          setState(() {
            isLoading = !isLoading;
          });
        }


      },
    );
  }

  _createCustomer(){
    Map<String, dynamic> customerMap = {
      "name":userLoginData['responseObject'][0]['DisplayName'],
      "contact":userLoginData['responseObject'][0]['MobileNo1'],
      "email":userLoginData['responseObject'][0]['EmailId'],
      "fail_existing":"0",
      // "notes":{
      //   "notes_key_1":"Tea, Earl Grey, Hot",
      //   "notes_key_2":"Tea, Earl Grey… decaf."
      // }
    };

    ServiceCall()
        .razorPayApiCall(context, Constant.RAZOR_PAY_BASE_URL+Constant.API_CREATE_CUSTOMER,
        customerMap)
        .then((response) async {
          setState(() {
            customerId = response['id'].toString();
          });
      print("value1324");
      print(response);

    });
  }

  _createOrder(){
    int total = int.parse(widget.amount) - int.parse(widget.discount);
    Map<String, dynamic> orderMap = {
      "amount": total*100,
      // "amount": 1*100,
      "currency": "INR",
      "receipt": "receipt#1",
      "notes": {
        "key1": "value3",
        "key2": "value2"
      }
    };

    ServiceCall()
        .razorPayApiCall(context, Constant.RAZOR_PAY_BASE_URL+Constant.API_CREATE_ORDER,
        orderMap)
        .then((response) async {
      print("orderMap1324");
      print(response);
      print(response['id']);
      _payOrder(response['id']);
    });

  }

  _payOrder(orderId){
    int total = int.parse(widget.amount) - int.parse(widget.discount);
    var options = {
      'key': Constant.KEY_ID,
      'amount': (total * 100).toString(),
      // 'amount': (1 * 100).toString(),
      //in the smallest currency sub-unit.
      'name': 'Counselinks.',
      // Generate order_id using Orders API
      'order_id' : orderId,
      'description': 'Package : ${widget.packageName}',
      'timeout': int.parse(Constant.TIMED_OUT),
      // in seconds
      'prefill': {
        'contact': userLoginData['responseObject'][0]['MobileNo1'],
        'email': userLoginData['responseObject'][0]['EmailId']
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  _capturePayments(paymentId){
    int total = int.parse(widget.amount) - int.parse(widget.discount);
    // String paymentId = "pay_JIHRdRNSKhlNHb";
    Map<String, dynamic> captureMap = {
      "amount": (total * 100).toString(),
      "currency": "INR"
    };
    ServiceCall()
        .razorPayApiCall(context, Constant.RAZOR_PAY_BASE_URL+Constant.API_PAYMENTS+"$paymentId"+Constant.API_CAPTURE_PAYMENT,
        captureMap)
        .then((response) async {
      print("capture1324");
      print(response);
      setState(() {
        _paymentsDetails(paymentId);
      });
      // print(response['id']);
      // _payOrder(response['id']);

    });
  }

  _paymentsDetails(paymentId){
    ServiceCall()
        .razorPayGetApiCall(context, Constant.RAZOR_PAY_BASE_URL+Constant.API_PAYMENTS+"$paymentId")
        .then((response) async {
      print("paymentDetails1324");
      print(response);
      print("method : "+response["method"]);
      setState(() {
        paymentType = response["method"];
        transactionId = response["method"] == 'upi' ? response["acquirer_data"]['rrn'].toString() : response["acquirer_data"]['bank_transaction_id'].toString();
        remarks = response["description"];
      });
     _finalSaveTransactionDetails();
      // print(response['id']);
      // _payOrder(response['id']);

    });
  }

  _alertDialogWidget(orderId, purchaseID) {
    int total = int.parse(widget.amount) - int.parse(widget.discount);
    print("total1324");
    print(total);
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return _openDialog(
          context,
          total == 0 ? "Package is added !!!" : 'Payment Successful !!!',
          orderId.isNotEmpty ? 'OrderId : $orderId' : "",
          "OK",
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
          height: height * 0.2,
          width: width,
          padding: const EdgeInsets.only(bottom: 5.0, left: 2.0, right: 2.0, top: 10.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFF91d0cc),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Util().getTextWithStyle1(
                  title: title,
                  color: Colors.red.shade900,
                  fontSize: width * 0.055,
                  fontWeight: FontWeight.w500,
              ),

              Expanded(
                child: Util().getTextWithStyle1(
                  title: description,
                  color: Colors.blueGrey.shade800,
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w500,
                ),
              ),


              RaisedButton(
                color: Colors.teal.shade200,
                // padding: EdgeInsets.fromLTRB(70, 15, 70, 15),
                padding: EdgeInsets.only(
                    left: width * 0.1,
                    right: width * 0.1,
                    bottom: 12,
                    top: 12),
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
                    color: Colors.grey.shade800,
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.w500),

                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    SlideRightRoute(
                      page: Home(),
                    ),
                  );
                  // Navigator.pop(context, false);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  _purchasePackageList(orderId, paymentId) {
    int total = int.parse(widget.amount) - int.parse(widget.discount);
    Map<String, dynamic> purchaseMap1 = {
      "objRequestPackageMaster": {
        "PackageMasterId": int.parse(widget.packageMasterId),
        "UserId": userLoginData['responseObject'][0]['UserId'],
        "Amount": total
      }
    };

    print("purchaseMap1");
    print(purchaseMap1);


    // setState(() {
    //   isLoading = !isLoading;
    // });
    // _loginUser(orderId, paymentId);

    ServiceCall()
        .apiCall(
        context,
        Constant.API_BASE_URL + Constant.API_PURCHASE_PACKAGE_LIST,
        purchaseMap1)
        .then((response) {
      if (response["responseCode"] == "1") {
        _updateUserDetail(orderId, paymentId);
      } else {
        // setState(() {
        //   isLoading = !isLoading;
        // });
        Util().displayToastMsg(response["responseMessage"].toString());
      }
    });
  }

  _updateUserDetail(orderId, paymentId) async {
    Map<String, dynamic> userMap = {
      "objReqOutsideLogin": {
        "MachineId": machineId,
        "Password": userPassword,
        "UserName": userEmail
      }
    };

    print("userMap");
    print(userMap);
    ServiceCall()
        .apiCall(context, Constant.API_BASE_URL + Constant.API_LOGIN_OUTSIDE,
        userMap)
        .then((value) async {

      if (value["responseCode"] == "1") {
        print(value["responseMessage"]);
        // Util().displayToastMsg(value["responseMessage"]);
        print("222222");
        print(value['responseObject'][0]['PackageExpired']);
        setState(() {
          _removeUserData();
          UserLoginResponse userLoginResponse =
          UserLoginResponse.fromJson(value);
          String userData = jsonEncode(userLoginResponse);

          // String userDetailMap = jsonEncode(detailMap);

          // String userData = jsonEncode(userData);
          SharedPrefData.setUserLoginData(userData);
          // SharedPrefData.setUserData(userDetailMap);

          _alertDialogWidget(orderId, paymentId);
          isLoading = !isLoading;
        });
      } else if (value["responseCode"] == "0") {
        // Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          isLoading = !isLoading;
        });
      }

      // print(value["responseObject"][0]["City"]);
      // print(value["responseObject"][0]["CounselingCategory"]);
    });
  }

  _removeUserData() async {
    print("11111");
    await SharedPrefData.removeUserLoginData(SharedPrefData.userLoginDataKey);
  }

  _saveTransactionDetails(){
    int total = int.parse(widget.amount) - int.parse(widget.discount);
    Map<String, dynamic> transactionMap = {
      "objRequestUserTransactionDetail":{
        "UserTransactionDetailId": "0",
        "PackageMasterId": widget.packageMasterId,
        "UserId": userLoginData['responseObject'][0]['UserId'],
        "Amount": widget.amount,
        "Discount":widget.discount,
        "FinalAmount":total,
        "InsertedUserID":0,
      }
    };

    ServiceCall()
        .apiCall(context, Constant.API_BASE_URL+Constant.API_SAVE_TRANSACTION_DETAIL,
        transactionMap)
        .then((response) async {
      print("responseTransaction");
      print(response);
      if(response['responseCode'] == "1"){
        setState(() {
          _createCustomer();
          _createOrder();
          userTransactionDetailId = response['responseObject']['UserTransactionDetailId'].toString();
        });
      }else{
        Util().displayToastMsg(response['responseMessage'].toString());
        setState(() {
          isLoading = !isLoading;
        });
      }

    });
  }

  _finalSaveTransactionDetails(){
    int total = int.parse(widget.amount) - int.parse(widget.discount);
    Map<String, dynamic> transactionMap = {
      "objRequestUserTransactionDetail":{
        "UserTransactionDetailId": userTransactionDetailId,
        "PackageMasterId": widget.packageMasterId,
        "UserId": userLoginData['responseObject'][0]['UserId'],
        "Amount": widget.amount,
        "Discount":widget.discount,
        "FinalAmount":total,
        "InsertedUserID":0,
        "CustomerId":customerId,
        "RazorpayOrderId":orderId,
        "PaymentId":paymentId,
        "PaymentType":paymentType,
        "PaymentTypeDetail":paymentTypeDetail,
        "ReceiptId":receiptId,
        "IsSuccess":"1",
        "Remarks":remarks,
        "BankTransactionNo": transactionId
      }
    };

    ServiceCall()
        .apiCall(context, Constant.API_BASE_URL+Constant.API_SAVE_TRANSACTION_DETAIL,
        transactionMap)
        .then((response) async {
      print("tansactionDetail");
      print(response);
      if(response["responseCode"] == "1"){
        setState(() {
          _updateUserDetail(orderId, paymentId);
          // _alertDialogWidget(orderId, paymentId);
          // isLoading = !isLoading;
        });
      }else{
        Util().displayToastMsg(response["responseMessage"]);
        setState(() {
          isLoading = !isLoading;
        });
      }
      

    });
  }
}
