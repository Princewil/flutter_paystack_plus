# flutter_paystack_plus

A Flutter plugin for making payments via the **Paystack Payment Gateway** — compatible with **Android**, **iOS**, and **Web**.

---

## Features

| Feature | Mobile (Android/iOS) | Web |
|---|:---:|:---:|
| Card Payment (VISA, Mastercard, etc.) | ✅ | ✅ |
| Bank Transfer | ✅ | ✅ |
| USSD | ✅ | ✅ |
| Mobile Money | ✅ | ✅ |
| QR Code | ✅ | ✅ |
| Split Payments | ✅ | ✅ |
| Subscription / Plan Payments | ✅ | ✅ |
| Server-side initialization & verification | ✅ | — |

---

## Getting Started

Before using this package, make sure you have a [Paystack](https://paystack.com) account and have your **public key** (and optionally your **secret key**) ready from the dashboard.

---

## Platform Setup

### 🌐 Web

**Step 1:** Create a file at `web/paystack_interop.js` and paste the following:

```js
function paystackPopUp(publicKey, email, amount, ref, plan, currency, onClosed, callback) {
  let handler = PaystackPop.setup({
    key: publicKey,
    email: email,
    amount: amount,
    ref: ref,
    plan: plan,
    currency: currency,
    onClose: function () {
      onClosed();
    },
    callback: function (response) {
      callback();
    },
  });
  return handler.openIframe();
}
```

**Step 2:** In `web/index.html`, add the Paystack inline script and your interop file inside the `<body>` tag:

```html
<body>
  <script src="https://js.paystack.co/v1/inline.js"></script>
  <script src="paystack_interop.js"></script>
  ...
</body>
```

---

### 🤖 Android

Set `minSdkVersion` to **19 or higher** in `android/app/build.gradle`:

```gradle
defaultConfig {
    applicationId "com.yourapp.id"
    minSdkVersion 19
    targetSdkVersion flutter.targetSdkVersion
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName
}
```

---

### 🍎 iOS

No additional setup required.

---

## Parameters

| Parameter | Required On | Description |
|---|---|---|
| `customerEmail` | All | Email address of the customer |
| `amount` | All | Amount **multiplied by 100** (e.g. ₦500 → `"50000"`) |
| `reference` | All | Unique alphanumeric transaction reference |
| `onSuccess` | All | Callback fired when a transaction completes |
| `onClosed` | All | Callback fired when the user cancels or payment fails |
| `publicKey` | Web only | Your Paystack public key |
| `context` | Mobile only | Flutter `BuildContext` — required to open the WebView |
| `callBackUrl` | Mobile only | Redirect URL configured in your Paystack dashboard — helps the WebView detect when to close |
| `secretKey` | Mobile (Package init) | Your Paystack secret key. Required when you want the **package** to initialize and verify the transaction. |
| `authorizationUrl` | Mobile (Server init) | Pre-generated Paystack checkout URL from **your own server**. Use this instead of `secretKey` to keep your secret key out of the app. |
| `currency` | Optional | Payment currency. Defaults to `NGN` (Naira) |
| `plan` | Optional | Plan code for subscription payments |
| `metadata` | Optional | Extra key-value data attached to the transaction |

> **Note:** For mobile, you must provide **either** `secretKey` **or** `authorizationUrl` — but not both.

---

## Usage

### Mode 1 — Package handles initialization & verification

The simplest mode. Pass your `secretKey` and the package will:
1. Call Paystack's `/transaction/initialize` to get the checkout URL
2. Open the checkout in a WebView
3. Call `/transaction/verify/{reference}` to confirm the result
4. Fire `onSuccess` or `onClosed` accordingly

```dart
await FlutterPaystackPlus.openPaystackPopup(
  context: context,
  customerEmail: 'customer@example.com',
  amount: (amount * 100).toString(), // e.g. 500 * 100 = 50000
  reference: DateTime.now().millisecondsSinceEpoch.toString(),
  secretKey: 'sk_live_your_secret_key',
  callBackUrl: 'https://your-callback-url.com', // from your Paystack dashboard
  currency: 'NGN',
  onSuccess: () {
    debugPrint('Payment successful!');
  },
  onClosed: () {
    debugPrint('Payment cancelled or failed.');
  },
);
```

---

### Mode 2 — Server-side initialization & verification

The more **secure** approach. Your backend holds the secret key — the app never sees it. You:
1. Call your server to initialize a Paystack transaction and receive the `authorization_url`
2. Pass that URL to `authorizationUrl`
3. The package opens it in a WebView and fires `onSuccess` when the flow ends
4. In `onSuccess`, call your server to verify the transaction using the reference

```dart
// Step 1: Initialize on your server
final authUrl = await myServer.initializePayment(
  email: 'customer@example.com',
  amount: 50000,
  reference: 'unique-ref-123',
);

// Step 2: Open the Paystack WebView
await FlutterPaystackPlus.openPaystackPopup(
  context: context,
  customerEmail: 'customer@example.com',
  amount: '50000',
  reference: 'unique-ref-123',
  authorizationUrl: authUrl, // from your server
  callBackUrl: 'https://your-callback-url.com',
  onSuccess: () {
    // Step 3: Verify on your server
    myServer.verifyPayment('unique-ref-123');
  },
  onClosed: () {
    debugPrint('Payment cancelled.');
  },
);
```

---

## Advanced: Split Payments (Web)

To enable split payments, update your `paystack_interop.js` handler:

**Single subaccount:**
```js
let handler = PaystackPop.setup({
  // ...existing fields...
  subaccount: 'ACCT_osl1da48je0lez6', // required
  transaction_charge: '2500',          // optional: flat fee override
  bearer: 'subaccount',               // optional: who bears transaction charges
});
```

**Multiple subaccounts (split code):**
```js
let handler = PaystackPop.setup({
  // ...existing fields...
  split_code: 'SPL_98WF13Eb3w', // required
});
```

---

## Advanced: Subscription Payments (Web)

To collect subscription payments, add a `plan` to your `paystack_interop.js` handler:

```js
let handler = PaystackPop.setup({
  // ...existing fields...
  plan: 'PLN_your_plan_code', // required: plan code from your dashboard
  quantity: '1',              // optional: quantity multiplier for the plan amount
});
```

For mobile, simply pass the `plan` parameter directly to `openPaystackPopup`.

---

## Contributors

This package stands on the shoulders of great contributors:

- **[Daniel Kabu Asare](https://github.com/popekabu)** — foundational work on the mobile platform via the [pay_with_paystack](https://pub.dev/packages/pay_with_paystack) package.
- **[George Ikwegbu Chinedu](https://github.com/gikwegbu)** — enhanced subscription functionalities for mobile.
- **[Jeremiah Oluwaseun Erinola](https://github.com/jeremiahseun)** — foundational implementation of split payment and subscription support.
- **[Kelvin Osei Poku](https://github.com/keezysilencer)** — expanded currency options for the web.
- **[Okpongu Tamarautukpamobowei](https://github.com/silentl007)** — fixed WebView reload issue caused by keyboard focus.

---

## Contributing & Issues

Contributions are very welcome! If you experience a bug or want to request a feature, please open an issue and be as descriptive as possible. Thank you! 🙏
