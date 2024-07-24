

# PayTech

## Installation

Paytech is available through [pub.dev]. To install  
it, simply add the following line to your pubspec.yam:

```yaml  
dependencies:  
 paytech: ^5.0.0 #latest flutter version( compileSdkVersion 34 for Android)  
```  

```yaml  
dependencies:  
 paytech: ^4.0.0 #flutter   
```  

```yaml  
dependencies:  
 paytech: ^3.0.2 #null-safety first introduction  
```  

```yaml  
dependencies:  
 paytech: ^0.1.2 #no null-safety support  
```  

## IMPORTANT
When making a request to `https://paytech.sn/api/payment/request-payment`, you should set the `success_url` and `cancel_url` fields to the respective values:
- ```https://paytech.sn/mobile/success``` for the success URL, and
- ```https://paytech.sn/mobile/cancel``` for the cancel URL.

```  
{  
"item_name":  "Business plane ticket Paris-Dakar",
"item_price":  560000, "currency":  "XOF",
"ref_command":  "RV3Q2LDUQ0FMP9F2EV2OFU8WV2K2VBZFED5R0QQO33IXSVTHSK48LD9GHXCO79",   "command_name":  "Purchase of three Paris Dakar business plane tickets for John Mcarty", "ipn_url":  "https://partner-domaine.com/api/ipn_callback",
"success_url":  "https://paytech.sn/mobile/success", 
"cancel_url":  "https://paytech.sn/mobile/cancel",
"custom_field":  "some_serialized_data"
}  
```  

Doing this will enable the plugin to handle the events accordingly.


## Example

To run the example project, clone the repo, and run `flutter pub  get` from the Example directory first.


Import PayTech Module

`import  'package:paytech/paytech.dart';`

Use `Paytech` widget to make a payment.
```dart  
onPressed: () async{  
 /** * Get this Url from Your backend * Your Backend must call https://paytech.sn/api/payment/request-payment to generate a payment token * Set success_url to https://paytech.sn/mobile/success * Set cancel_url to https://paytech.sn/mobile/cancel */ var paymentUrl = "https://paytech.sn/payment/checkout/729b3e3021226cd27905";  
 
 bool paymentResult = await Navigator.push( context, MaterialPageRoute(builder: (context) => PayTech(paymentUrl)), ) ;  
 
 if(paymentResult){ print("Payment success"); } else{ print("Payment failed"); }},  
```  


## PayTech Widget

You can pass optional additional arguments to PayTech constructor:
```dart  
{  
 backButtonIcon: IconData, //default Icons.arrow_back_ios 
 appBarTitle: String, //default "PayTech" 
 centerTitle: bool, //default true 
 appBarBgColor: Color,  //default Color(0xFF1b7b80) 
 appBarTextStyle: TextStyle,  //default TextStyle(), 
 hideAppBar: bool, //default false
 }  
```  

## Web support (only for > paytech 5.0.0)
Update web/index.html  
For the web platform, you need to include the web_support.js file provided by the plugin in your web/index.html file. This file helps in initializing the WebView for Flutter Web.

- download web_support.js from ```https://raw.githubusercontent.com/touskar/paytech-flutter/master/web_support.js```
- include it in ```/assets/packages/paytech/assets/web/``` - Add the following script tag to the <head> section of your web/index.html:

```  
<head>  
 <!-- ... --> 
 <script type="application/javascript" src="/assets/packages/paytech/assets/web/web_support.js" defer></script> 
 <!-- ... --></head>  
```  

## Author

Moussa Ndour (moussa.ndour@intech.sn / WhatsApp +221772457199)  
contact@paytech.sn  
https://intech.sn  
https://paytech.sn

## License

PayTech is available under the MIT license. See the LICENSE file for more info.
