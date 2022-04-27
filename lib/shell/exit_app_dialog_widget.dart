import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constant.dart';
import '../core/util.dart';

class ExitAppDialogWidget extends StatefulWidget {
  final String title, descriptions, yes, no;


  ExitAppDialogWidget(
      {required this.title,
        required this.descriptions,
        required this.yes,
        required this.no}); // const ExitAppDialogWidget(
  //     {Key key, this.title, this.descriptions, this.yes, this.no})
  //     : super(key: key);

  @override
  _ExitAppDialogWidgetState createState() => _ExitAppDialogWidgetState();
}

class _ExitAppDialogWidgetState extends State<ExitAppDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constant.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    double width = Util().getScreenWidth(context);
    double height = Util().getScreenHeight(context);
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFF91d0cc).withOpacity(1.0),
            borderRadius: BorderRadius.circular(10.0),

          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Util().getTextWithStyle1(
                  title: widget.title,
                  color: Colors.blueGrey.shade700,
                  fontSize: width * 0.053,
                  fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                child: Util().getTextWithStyle1(
                    title: widget.descriptions,
                    color: Colors.blueGrey.shade800,
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: height * 0.032,
              ),


              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RaisedButton(
                    color: Colors.teal.shade200,
                    // padding: EdgeInsets.fromLTRB(70, 15, 70, 15),
                    padding: EdgeInsets.only(left: width * 0.16,right: width * 0.16, bottom: 15, top: 15,),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                      ),
                    ),
                    child: Util().getTextWithStyle1(
                        title: widget.no.toUpperCase(),
                        color: Colors.white70,
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w500,
                    ),

                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Colors.teal.shade100,
                      // padding: EdgeInsets.fromLTRB(70, 15, 70, 15),
                      padding: EdgeInsets.only(left: width * 0.16,right: width * 0.15, bottom: 15, top: 15,),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Util().getTextWithStyle1(
                          title: widget.yes.toUpperCase(),
                          color: Colors.blueGrey.shade900,
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.w500,
                      ),

                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    ),
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
