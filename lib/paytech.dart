library paytech;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:url_launcher/url_launcher.dart';

const MOBILE_CANCEL_URL = "https://paytech.sn/mobile/cancel";
const MOBILE_SUCCESS_URL = "https://paytech.sn/mobile/success";

class PayTech extends StatefulWidget {
  final String paymentUrl;
  final String appBarTitle;
  final bool centerTitle;
  final Color appBarBgColor;
  final TextStyle appBarTextStyle;
  final IconData backButtonIcon;
  final bool hideAppBar;

  PayTech(this.paymentUrl,
      {this.hideAppBar = false,
      this.backButtonIcon = Icons.arrow_back_ios,
      this.appBarTitle = "PayTech",
      this.centerTitle = true,
      this.appBarBgColor = const Color(0xFF1b7b80),
      this.appBarTextStyle = const TextStyle()});

  @override
  _PayTechState createState() => _PayTechState();
}

class _PayTechState extends State<PayTech> {
  late FlutterWebviewPlugin flutterWebviewPlugin;

  bool onClosing = false;

  @override
  void initState() {
    _initcontroller();
    super.initState();

    if (widget.hideAppBar) {
      // WidgetsFlutterBinding.ensureInitialized();
      FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);
    }
  }

  @override
  Widget build(BuildContext context) {
    /*if(widget.hideAppBar){
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setEnabledSystemUIOverlays([]);
    }*/

    return new WebviewScaffold(
      url: widget.paymentUrl,
      hidden: false,
      withLocalStorage: true,
      withJavascript: true,
      useWideViewPort: true,
      supportMultipleWindows: true,
      scrollBar: false,
      javascriptChannels:
          <JavascriptChannel>[_openDialJavascriptChannel(context)].toSet(),
      debuggingEnabled: Platform.isAndroid && !kReleaseMode ? true : false,
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              title: new Text(
                widget.appBarTitle,
                style: widget.appBarTextStyle,
              ),
              backgroundColor: widget.appBarBgColor,
              //backgroundColor: APP_PRIMARY_COLOR,
              centerTitle: widget.centerTitle,
              leading: IconButton(
                icon: Icon(widget.backButtonIcon, color: Colors.white),
                onPressed: () {
                  _close(false);
                },
              ),
            ),
    );
  }

  void _initcontroller() {
    flutterWebviewPlugin = new FlutterWebviewPlugin();

    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      String url = state.url;
      if (url.contains(MOBILE_SUCCESS_URL) || url.contains(MOBILE_CANCEL_URL)) {
        bool result = url.contains("success") ? true : false;
        _close(result);
      }
    });
  }

  void _close(bool success) async {
    if (!onClosing) {
      onClosing = true;
      flutterWebviewPlugin.close();
      Navigator.of(context).pop(success);
      await FullScreen.exitFullScreen();
    }
  }

  JavascriptChannel _openDialJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'FlutterChanelOpenDial',
        onMessageReceived: (JavascriptMessage message) {
          String phone = message.message;
          launch(Uri.encodeFull("tel:$phone"));
        });
  }
}
