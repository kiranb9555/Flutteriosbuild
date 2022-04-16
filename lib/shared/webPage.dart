import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../core/util.dart';

class WebPage extends StatefulWidget {
  String url = "";

  WebPage(this.url, {Key? key}) : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  bool isLoading = true;
  final _key = UniqueKey();

  // AdmobInterstitial interstitialAd;

  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    _scrollViewController = new ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });

    // _showInterstitialAdId();
    // setState(() {
    //   interstitialAd = AdmobInterstitial(
    //     adUnitId: ams.getInterstitialAdId(),
    //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {
    //       if (event == AdmobAdEvent.closed) interstitialAd.load();
    //       // handleEvent(event, args, 'Interstitial');
    //     },
    //   );
    // });

    // interstitialAd.load();
    super.initState();
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    // Add these to dispose to cancel timer when user leaves the app
    // interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = Util().getScreenHeight(context);
    double width = Util().getScreenWidth(context);
    // _showInterstitialAdId();
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: buildAppbar(),
      body: Container(
        margin: EdgeInsets.only(top: height * 0.0363,bottom: height* 0.001),
        height: Util().getScreenHeight(context),
        child: Column(
          children: <Widget>[
            Expanded(
                child: Stack(
              children: <Widget>[
                WebView(
                  key: _key,
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (finish) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                isLoading
                    ? Container(
                        height: height,
                        width: width,
                        color: Colors.teal.withOpacity(0.1),
                        child: Center(
                          child: Util().loadIndicator(),
                        ),
                      )
                    : Stack(),
              ],
            )),
            // Container(
            //   // height: 50.0,
            //   child: AdmobBanner(
            //     adUnitId: ams.getBannerAdId(),
            //     adSize: AdmobBannerSize.ADAPTIVE_BANNER(
            //         width: MediaQuery.of(context).size.width.toInt()),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // _showInterstitialAdId() async {
  //   if (await interstitialAd.isLoaded) {
  //     interstitialAd.show();
  //   }
  // }

  AppBar buildAppbar() {
    return AppBar(
      backgroundColor: Colors.blueGrey.shade100,
      elevation: 0.0,
      title: Text(
        widget.url,
        style: GoogleFonts.aBeeZee(
          fontWeight: FontWeight.w500,
          color: Colors.blueGrey.shade700,
          fontSize: 13.0,
        ),
      ),
      // centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.blueGrey.shade700,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
