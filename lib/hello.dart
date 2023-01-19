import 'dart:async';

import 'package:flutter/material.dart';
import 'package:paytech/paytech.dart';

class AppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("PayTech"),
      ),
      body: Center(
        child: Builder(
          builder: (context) => ElevatedButton(
            child: Text('Make Payment'),
            onPressed: () async {
              var paymentUrl =
                  "https://paytech.sn/payment/checkout/729b3e3021226cd27905";

              bool paymentResult = await (Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PayTech(paymentUrl)),
              ) as FutureOr<bool>);

              if (paymentResult) {
                print("Payment success");
              } else {
                print("Payment failed");
              }
            },
          ),
        ),
      ),
    );
  }
}
