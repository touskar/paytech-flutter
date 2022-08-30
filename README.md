
# PayTech


## Requirements
 minSdkVersion 17

## Installation

Paytech is available through [pub.dev]. To install
it, simply add the following line to your pubspec.yam:

```yaml
dependencies:
  paytech: ^3.0.1 #null-safety
```

```yaml
dependencies:
  paytech: ^0.1.2 #no null-safety support
```

## Example

To run the example project, clone the repo, and run `flutter pub  get` from the Example directory first.


Import PayTech Module

`import  'package:paytech/paytech.dart';`

Use `Paytech`  widget to make a payment.
```dart
onPressed: () async{
  /**
   * Get this Url from Your backend
   * Your Backend must call https://paytech.sn/api/payment/request-payment to generate a payment token
   * Set success_url to https://paytech.sn/mobile/success
   * Set cancel_url to https://paytech.sn/mobile/cancel
   */
  var paymentUrl = "https://paytech.sn/payment/checkout/729b3e3021226cd27905";

  bool paymentResult = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PayTech(paymentUrl)),
  ) ;

  if(paymentResult){
    print("Payment success");
  }
  else{
    print("Payment failed");
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
  appBarTextStyle: TextStyle,  default TextStyle(),
  hideAppBar: bool, default false
}
```


## Author

Moussa Ndour (moussa.ndour@intech.sn / +221772457199)
https://discord.gg/Y6ke2MmNGF (paytech channel)
contact@paytech.sn
https://intech.sn
https://paytech.sn

## License

PayTech is available under the MIT license. See the LICENSE file for more info.
