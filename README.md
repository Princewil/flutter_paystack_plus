<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A Flutter plugin for making payments via Paystack Payment Gateway - Compatible on Android, iOS and Web.

## Features

- Mobile Money

- VISA

- Bank

- Bank Transfer

- USSD

- QR

## Getting started

Before getting started, ensure you have succesfully created an account on paystack and you have your public key ready. Vist https://paystack.com to setup your account.

A. FOR WEB COMPATIBILITY: Ensure you do the following

1. Create a file on your web folder and call it "paystack_interop.js"

2. Copy and paste the code below on the created folder
```dart
function paystackPopUp(publicKey, email, amount, ref, onClosed, callback) {
  let handler = PaystackPop.setup({
    key: publicKey,
    email: email,
    amount: amount,
    ref: ref,
    onClose: function () {
      alert("Window closed.");
      onClosed();
    },
    callback: function (response) {
      callback();
      let message = "Payment complete! Reference: " + response.reference;
      alert(message);
    },
  });
  return handler.openIframe();
}
```
3. In your web/index.html file add the following code at the top of the body tag section
```dart
<body>
<script src="https://js.paystack.co/v1/inline.js"></script>
<script src="paystack_interop.js"></script>
...
...
</body>
```


B. FOR ANDROID COMPATIBILITY: Ensure your minSdkVersion is 19 or higher

```dart
defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId '...'
        minSdkVersion 19 // Ensure this line is 19 or higher
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
```


C. NO SETUP REQUIRED for iOS

## Some important parameters

- [publicKey] is required for web only
- [secretKey] is required for Mobile only
- [context] is required for Mobile only
- [amount] should be multiplied by 100 [eg amount * 100]
- [onClose] is called when the user cancels a transaction or when there is a failed transaction
- [onSuccess] is called on successful transactions
- [callBackURL] is required for Mobile only. Users are redirected to this URL after payment is successful, this helps close the session. The URL is setup in your Dashboard and then provided here.

## Usage

```dart
     FlutterPaystackPlus.openPaystackPopup(
      publicKey: '-Your-public-key-',
      customerEmail: 'youremail@gmail.com',
      context: context,
      secretKey: '-Your-secret-key-',
      amount: (amount * 100).toString(),
      reference: DateTime.now().millisecondsSinceEpoch.toString(),
      callBackUrl: "[GET IT FROM YOUR PAYSTACK DASHBOARD]",
      onClosed: () {
        debugPrint('Could\'nt finish payment');
      },
      onSuccess: () async {
        debugPrint('successful payment');
      },
    );
```

## Contributor(s)
I would like to thank [gikwegbu](https://github.com/gikwegbu) for his valuable contribution to this project.


## Additional information
Please feel very free to contribute. Experienced an issue or want to report a bug? Please, feel free to report it. Remember to be as descriptive as possible. 
Thank you.
