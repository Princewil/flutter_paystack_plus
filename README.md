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

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

1. Create a file on yor web folder called "paystack_interop.js"
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


## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
 PaystackPopup.openPaystackPopup(
    publicKey:'Your public key'
    email: 'youremail@gmail.com',
    amount: (amount * 100).toString(),
    ref: ref,
    onClosed: () {
    debugPrint('Could\'nt finish payment');
    },
    onSuccess: () {
    debugPrint('successful payment');
    },
    );
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
