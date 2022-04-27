import 'package:Counselinks/module/transaction_history.dart';
import 'package:flutter/material.dart';
import '../core/constant.dart';
import '../core/util.dart';
import '../shared/slide_left_route.dart';

class TransactionDetail extends StatefulWidget {
  final transactionList ;
  final int index;
  const TransactionDetail({Key? key, required this.transactionList,
    required this.index,}) : super(key: key);

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Util().boxDecoration(),
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            SlideLeftRoute(
              page: TransactionHistory(),
            ),
          );
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: Util().getAppBar(
            context,
            "Transaction Details",
            Util().getScreenHeight(context),
            Util().getScreenHeight(context),
          ),
          body: _body(),
        ),
      ),
    );
  }

  _body(){
  return Container(
    padding: const EdgeInsets.only(left: 3.0, right: 3.0),
      height :Util().getScreenHeight(context),
      width: Util().getScreenWidth(context),
    child: Column(
      children: [
        _getCard(),
        _getTransactionMethodID(),
        _getRemarks(),
      ],
    ),
  );
  }

  _getCard() {
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
                      title: widget.transactionList[widget.index]['PackageName'].toString() + " . " +widget.transactionList[widget.index]['PurchaseOn'].toString(),
                      color: Colors.blueGrey.shade800,
                      fontSize: fontSize * 0.021,
                      fontWeight: FontWeight.w500,
                    ),
                    Util().getTextWithStyle1(
                      title: "Amount : " + Constant.rupee +
                          widget.transactionList[widget.index]['PaidAmount'].toString(),
                      color: Colors.green.shade800,
                      fontSize: fontSize * 0.021,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                )
              ],
            ),
            // Icon(
            //   Icons.arrow_forward_ios,
            //   color: Colors.blueGrey.shade800,
            //   size: height * 0.02,
            // ),
          ],
        ),
      ),
    );
  }

  _getTransactionMethodID() {
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
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        height: height / 10,
        width: width,
        color: Colors.white38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Util().getTextWithStyle1(
              title: "Payment Type : \n" +
                  widget.transactionList[widget.index]['PaymentType'].toString(),
              color: Colors.blueGrey.shade800,
              fontSize: fontSize * 0.021,
              fontWeight: FontWeight.w500,
            ),
            Util().getTextWithStyle1(
              title: "Transaction Id : \n"+
                  widget.transactionList[widget.index]['BankTransactionNo'].toString(),
              color: Colors.blueGrey.shade800,
              fontSize: fontSize * 0.021,
              fontWeight: FontWeight.w500,
            ),
          ],
        )
      ),
    );
  }

  _getRemarks() {
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
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        height: height / 20,
        width: width,
        color: Colors.white38,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Util().getTextWithStyle1(
              title: "Remarks : ",
              color: Colors.blueGrey.shade800,
              fontSize: fontSize * 0.021,
              fontWeight: FontWeight.w500,
            ),
            Util().getTextWithStyle1(
              title: "",
              color: Colors.green.shade800,
              fontSize: fontSize * 0.021,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

}
