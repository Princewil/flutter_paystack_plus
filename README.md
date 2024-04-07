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

## What's New?

- Split payment

- Subscription payment



## Other Features

- Mobile Money

- VISA

- Bank

- Bank Transfer

- USSD

- QR

- Split Payments

- Subscriptions

## Getting started

Before getting started, ensure you have succesfully created an account on paystack and you have your public key ready. Vist <https://paystack.com> to setup your account.

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

## Split Payments

You can split your payment into single or multiple subaccounts.

Here is how you can do that:

- Single Split Payment

In your "paystack_interop.js" file, you can add:

```js
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
        //* NEW LINES
        //* Required
        subaccount: "<CODE_ID_OF_SUBACCOUNT>"  // It looks like "ACCT_osl1da48je0lez6"
        //* Optional
        transaction_charge: "2500" // If you want to override the percentage and use the flat fee.
        //* Optional
        bearer: "subaccount" // Decide who will bear Paystack transaction charges between account and subaccount. Defaults to account
        //* End of Subaccount
          });
    return handler.openIframe();
```

- Multi Split Payment

In your "paystack_interop.js" file, you can add:

```js
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
        //* NEW LINES
        //* Required
        split_code: "<CODE_ID_OF_SUBACCOUNT>"  // It looks like "SPL_98WF13Eb3w. The split code of the transaction split"
        //* End of Subaccount
          });
    return handler.openIframe();
```

## Subscriptions

You can also get subscription payments also.

Here is how you can do that:
In your "paystack_interop.js" file, you can add:

```js
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
        //* NEW LINES
        //* Required
        plan: "<PLAN_CODE>"  // Plan code generated from creating a plan. This makes the payment become a subscription payment
        //* Optional
        quantity: "10" // Used to apply a multiple to the amount returned by the plan code above.
        //* End of Subaccount
          });
    return handler.openIframe();
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

I also want appreciate [jeremiahseun](https://github.com/jeremiahseun) for his work in making the split payment and subscription functionalities possible.

## Additional information

Please feel very free to contribute. Experienced an issue or want to report a bug? Please, feel free to report it. Remember to be as descriptive as possible.
Thank you.
