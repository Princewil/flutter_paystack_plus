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

A Flutter plugin for making payments via Paystack Payment Gateway. Fully supports Android, iOS and Web.

## Features

- Mobile Money

- VISA

- Bank

- Bank Transfer

- USSD

- QR

- EFT

## Getting started

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

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
     FlutterPaystackPlus.openPaystackPopup(
      publicKey: '-Your-public-key-',
      email: 'youremail@gmail.com',
      amount: (amount * 100).toString(),
      ref: DateTime.now().millisecondsSinceEpoch.toString(),
      onClosed: () {
        debugPrint('Could\'nt finish payment');
      },
      onSuccess: () async {
        debugPrint('successful payment');
      },
    );
```

## Additional information
Here is a detailed example project => https://github.com/Princewil/flutter_paystack_plus_example 
