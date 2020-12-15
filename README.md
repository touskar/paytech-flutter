
# PayTech


## Installation

Paytech is available through [pub.dev](https://cocoapods.org). To install
it, simply add the following line to your pubspec.yam;:

```yaml
dependencies:
  paytech: ^0.0.1
```

## Example

To run the example project, clone the repo, and run `flutter pub  get` from the Example directory first.


Import Paytech Module

`import  'package:paytech/paytech.dart';`

Use `Paytech`  widget to make a payment.
```dart
onPressed: () async{
  var paymentUrl = "https://paytech.sn/payment/checkout/729b3e3021226cd27905";

  bool paymentResult = await Navigator.push(
    context,
  MaterialPageRoute(builder: (context) => PayTech(paymentUrl)),
  );

 if(paymentResult){
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: Text("Payment success")
    ));
  }
  else{
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: Text("Payment failed")
    ));
  }
},
```


## PayTech Widget

You can pass optional additional arguments to PayTech constructor:
```dart
{
  backButtonIcon: IconData, default Icons.arrow_back_ios
  appBarTitle: String, default "PayTech"
  centerTitle: bool, default true
  appBarBgColor: Color,  default Color(0xFF1b7b80)
  appBarTextStyle: TextStyle,  default TextStyle()
}
```


## Author

PayTech, contact@paytech.sn

## License

Paytech is available under the MIT license. See the LICENSE file for more info.
