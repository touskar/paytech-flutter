library paytech_flutter;

import 'package:flutter/material.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String mobileCancelUrl = "https://paytech.sn/mobile/cancel";
const String mobileSuccessUrl = "https://paytech.sn/mobile/success";

class PayTech extends StatefulWidget {
  final String paymentUrl;
  final String appBarTitle;
  final bool centerTitle;
  final Color appBarBgColor;
  final TextStyle appBarTextStyle;
  final IconData backButtonIcon;
  final bool hideAppBar;

  const PayTech(
    this.paymentUrl, {
    super.key,
    this.hideAppBar = false,
    this.backButtonIcon = Icons.arrow_back_ios,
    this.appBarTitle = "PayTech",
    this.centerTitle = true,
    this.appBarBgColor = const Color(0xFF1b7b80),
    this.appBarTextStyle = const TextStyle(),
  });

  @override
  State<PayTech> createState() => _PayTechState();
}

class _PayTechState extends State<PayTech> {
  late WebViewController controller;
  bool onClosing = false;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..platform
      ..loadRequest(Uri.parse(widget.paymentUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              title: Text(
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
      body: WebViewWidget(controller: controller),
    );
  }

  void _close(bool success) async {
    if (!onClosing) {
      onClosing = true;
      Navigator.of(context).pop(success);
      await FullScreen.exitFullScreen();
    }
  }
}
