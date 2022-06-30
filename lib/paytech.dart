library paytech;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

const MOBILE_CANCEL_URL = "https://paytech.sn/mobile/cancel";
const MOBILE_SUCCESS_URL = "https://paytech.sn/mobile/success";

class PayTech extends StatefulWidget {
  final String paymentUrl;
  final String? appBarTitle;
  final bool? centerTitle;
  final Color? appBarBgColor;
  final TextStyle? appBarTextStyle;
  final IconData? backButtonIcon;
  final bool? hideAppBar;
  const PayTech(
      {Key? key,
      required this.paymentUrl,
      this.hideAppBar = false,
      this.backButtonIcon = Icons.arrow_back_ios,
      this.appBarTitle = "PayTech",
      this.centerTitle = true,
      this.appBarBgColor = const Color(0xFF1b7b80),
      this.appBarTextStyle = const TextStyle()})
      : super(key: key);

  @override
  State<PayTech> createState() => _PayTechState();
}

class _PayTechState extends State<PayTech> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hideAppBar!
          ? null
          : AppBar(
              title: new Text(
                widget.appBarTitle!,
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
      body: WebView(
        initialUrl: widget.paymentUrl,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: <JavascriptChannel>{
          _openDialJavascriptChannel(context),
          _openUrlJavascriptChannel(context)
        },
        onPageStarted: (url) {
          if (url.contains(MOBILE_SUCCESS_URL) ||
              url.contains("cancel") ||
              url.contains(MOBILE_CANCEL_URL)) {
            bool result = url.contains("success") ? true : false;
            _close(result);
          }
        },
      ),
    );
  }

  void _close(bool success) async {
    Navigator.pop(context, success);
  }

  JavascriptChannel _openDialJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'FlutterChanelOpenDial',
        onMessageReceived: (JavascriptMessage message) {
          String phone = message.message;
          launchUrl(Uri(scheme: 'tel', path: phone));
        });
  }

  JavascriptChannel _openUrlJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'FlutterChanelOpenUrl',
        onMessageReceived: (JavascriptMessage message) {
          String url = message.message;
          launchUrl(Uri.parse(url));
        });
  }
}
