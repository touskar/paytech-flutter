library paytech;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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

  PayTech(this.paymentUrl, {this.hideAppBar = false, this.backButtonIcon = Icons.arrow_back_ios, this.appBarTitle = "PayTech", this.centerTitle = true, this.appBarBgColor = const Color(0xFF1b7b80), this.appBarTextStyle = const TextStyle()});

  @override
  _PayTechState createState() => _PayTechState();
}

class _PayTechState extends State<PayTech> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  late InAppWebViewSettings options;

  bool onClosing = false;

  void gotoFullscreen() {

  }

  void exitFullscreen() {
   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void initState() {
    super.initState();
    initWebView();

    if(widget.hideAppBar){
     gotoFullscreen();
    }

  }


  @override
  Widget build(BuildContext context) {
    print("seting chrome");
    if(!widget.hideAppBar){
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: widget.appBarBgColor,
        // Color for Android
        statusBarBrightness: Brightness.dark,
        // Dark == white status bar -- for IOS.
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: widget.appBarBgColor
      ));
    }
    else{

    }


    return Scaffold(
      appBar: widget.hideAppBar ? null :  AppBar(
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
      body: Container(
        color: widget.hideAppBar ? widget.appBarBgColor.withOpacity(0.5) : Colors.transparent,
        child: SafeArea(
          child: Container(
            child: InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: WebUri(widget.paymentUrl)),
              initialSettings: options,
              shouldAllowDeprecatedTLS: (controller, challenge) async {
                // Always allow deprecated TLS certificates
                return ShouldAllowDeprecatedTLSAction.ALLOW;
              },
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                // Example: Allow all certificates (not recommended for production)
                return  ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
              },
              onWebViewCreated: (controller) {
                webViewController = controller;
                onWebViewCreated(controller);
              },
              onLoadStart: (controller, url) {
                  this.onLoadStart(controller, url?.toString() ?? '');
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                //var uri = navigationAction.request.url;
                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                  this.onLoadStop(controller, url?.toString() ?? '');
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },

            ),
          ),
        ),
      ),
    );
  }


  void initWebView() {


    options =  InAppWebViewSettings(
      // Cross-platform settings
      useShouldInterceptRequest: true,
      useOnLoadResource: true,
      useOnDownloadStart: false,
      clearCache: false,
      userAgent: getUserAgent(),
      javaScriptEnabled: true,
      javaScriptCanOpenWindowsAutomatically: true,
      mediaPlaybackRequiresUserGesture: false,
      minimumFontSize: 0,
      verticalScrollBarEnabled: true,
      horizontalScrollBarEnabled: true,
      resourceCustomSchemes: [],
      contentBlockers: [],
      preferredContentMode: UserPreferredContentMode.RECOMMENDED,
      useShouldInterceptAjaxRequest: false,
      interceptOnlyAsyncAjaxRequests: true,
      useShouldInterceptFetchRequest: false,
      incognito: false,
      cacheEnabled: true,
      transparentBackground: false,
      disableVerticalScroll: false,
      disableHorizontalScroll: false,
      disableContextMenu: false,
      supportZoom: true,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      textZoom: 100,
      clearSessionCache: false,
      builtInZoomControls: true,
      displayZoomControls: false,
      databaseEnabled: true,
      domStorageEnabled: true,
      useWideViewPort: true,
      safeBrowsingEnabled: true,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW, // Set as appropriate
      allowContentAccess: true,
      allowFileAccess: true,
      blockNetworkImage: false,
      blockNetworkLoads: false,
      cacheMode: CacheMode.LOAD_DEFAULT,
      cursiveFontFamily: "cursive",
      defaultFixedFontSize: 16,
      defaultFontSize: 16,
      defaultTextEncodingName: "UTF-8",
      fantasyFontFamily: "fantasy",
      fixedFontFamily: "monospace",
      forceDark: ForceDark.OFF,
      forceDarkStrategy: ForceDarkStrategy.PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING,
      geolocationEnabled: true,
      layoutAlgorithm: LayoutAlgorithm.NORMAL,
      loadWithOverviewMode: true,
      loadsImagesAutomatically: true,
      minimumLogicalFontSize: 8,
      needInitialFocus: true,
      offscreenPreRaster: false,
      sansSerifFontFamily: "sans-serif",
      serifFontFamily: "sans-serif",
      standardFontFamily: "sans-serif",
      saveFormData: true,
      thirdPartyCookiesEnabled: true,
      hardwareAcceleration: true,
      initialScale: 0,
      supportMultipleWindows: false,
      useHybridComposition: true,
      useOnRenderProcessGone: false,
      overScrollMode: OverScrollMode.IF_CONTENT_SCROLLS,
      networkAvailable: true, // Example value
      scrollBarStyle: ScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY,
      verticalScrollbarPosition: VerticalScrollbarPosition.SCROLLBAR_POSITION_DEFAULT,
      scrollBarDefaultDelayBeforeFade: 1000,
      scrollbarFadingEnabled: true,
      disableDefaultErrorPage: false,
      verticalScrollbarThumbColor: Colors.grey,
      verticalScrollbarTrackColor: Colors.black,
      horizontalScrollbarThumbColor: Colors.grey,
      horizontalScrollbarTrackColor: Colors.black,
      algorithmicDarkeningAllowed: false,
      enterpriseAuthenticationAppLinkPolicyEnabled: true,
      //  defaultVideoPoster: '',
     // requestedWithHeaderOriginAllowList: [],
      disallowOverScroll: false,
      enableViewportScale: false,
      suppressesIncrementalRendering: false,
      allowsAirPlayForMediaPlayback: true,
      allowsBackForwardNavigationGestures: true,
      allowsLinkPreview: true,
      ignoresViewportScaleLimits: false,
      allowsInlineMediaPlayback: true,
      allowsPictureInPictureMediaPlayback: true,
      isFraudulentWebsiteWarningEnabled: true,
      selectionGranularity: SelectionGranularity.DYNAMIC,
      dataDetectorTypes: [DataDetectorTypes.NONE],
      sharedCookiesEnabled: false,
      automaticallyAdjustsScrollIndicatorInsets: false,
      accessibilityIgnoresInvertColors: false,
      decelerationRate: ScrollViewDecelerationRate.NORMAL,
      alwaysBounceVertical: false,
      alwaysBounceHorizontal: false,
      scrollsToTop: true,
      isPagingEnabled: false,
      maximumZoomScale: 1.0,
      minimumZoomScale: 1.0,
      contentInsetAdjustmentBehavior: ScrollViewContentInsetAdjustmentBehavior.NEVER,
      isDirectionalLockEnabled: false,
     // mediaType: MediaType.ALL,
      pageZoom: 1.0,
      limitsNavigationsToAppBoundDomains: false,
      useOnNavigationResponse: false,
      applePayAPIEnabled: false,
     // allowingReadAccessTo: [],
      disableLongPressContextMenuOnLinks: false,
      disableInputAccessoryView: false,
      underPageBackgroundColor: Colors.transparent,
      isTextInteractionEnabled: true,
      isSiteSpecificQuirksModeEnabled: true,
      upgradeKnownHostsToHTTPS: true,
      isElementFullscreenEnabled: true,
      isFindInteractionEnabled: false,
      minimumViewportInset: EdgeInsets.all(0),
      maximumViewportInset: EdgeInsets.all(0),
      isInspectable: false,
      shouldPrintBackgrounds: false,
      allowBackgroundAudioPlaying: false,
      webViewAssetLoader: null,
      iframeAllow: "*",
      iframeAllowFullscreen: true,
     // iframeSandbox: [],
      iframeReferrerPolicy: ReferrerPolicy.NO_REFERRER,
      iframeName: "",
      iframeCsp: "",
    );

  }


  void _close(bool success) async{
    if(!onClosing){
      onClosing  = true;
      //webViewController.close();
      Navigator.of(context).pop(success);

      if(widget.hideAppBar){
        exitFullscreen();
      }
    }
  }


  void onLoadStop(InAppWebViewController controller, String url) {
    if (url.contains(MOBILE_SUCCESS_URL) || url.contains(MOBILE_CANCEL_URL)) {
      bool result = url.contains("success") ? true : false;
      _close(result);
    }
  }

  void onLoadStart(InAppWebViewController controller, String url) {
    if (url.contains(MOBILE_SUCCESS_URL) || url.contains(MOBILE_CANCEL_URL)) {
      bool result = url.contains("success") ? true : false;
      _close(result);
    }
  }

  void onWebViewCreated(InAppWebViewController controller) {
    controller.addJavaScriptHandler(handlerName: 'FlutterChanelOpenUrl', callback: (args) {
      String url = args[0].toString();
      print("FlutterChanelOpenUrl Call");
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    });

    controller.addJavaScriptHandler(handlerName: 'FlutterChanelOpenDial', callback: (args) {
      String phone = args[0].toString();
      print("FlutterChanelOpenDial Call");
      String encodedPhone = Uri.encodeComponent(phone);
      Uri phoneUri = Uri(scheme: 'tel', path: encodedPhone);
      launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    });
  }

  String getUserAgent() {
    if (Platform.isIOS) {
      return "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Mobile/15E148 Safari/604.1/PayTech";
    } else if (Platform.isAndroid) {
      // User Agent for Android
      return "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Mobile Safari/537.36/PayTech";
    }

    return "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36/PayTech";
  }
}
