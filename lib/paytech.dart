library paytech;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
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

  PayTech(this.paymentUrl, {this.backButtonIcon = Icons.arrow_back_ios, this.appBarTitle = "PayTech", this.centerTitle = true, this.appBarBgColor = const Color(0xFF1b7b80), this.appBarTextStyle = const TextStyle()});

  @override
  _PayTechState createState() => _PayTechState();
}

class _PayTechState extends State<PayTech> {
  FlutterWebviewPlugin flutterWebviewPlugin;

  @override
  void initState() {
    _initcontroller();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: new AppBar(
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

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains(MOBILE_SUCCESS_URL) || url.contains(MOBILE_CANCEL_URL)) {
        bool result = url.contains("success") ? true : false;
        _close(result);
      }
    });
  }

  void _close(bool success) {
    flutterWebviewPlugin?.close();
    Navigator.of(context).pop(success);
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
