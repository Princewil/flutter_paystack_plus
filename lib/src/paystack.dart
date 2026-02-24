import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';

class FlutterPaystackPlus {
  static Future<void> openPaystackPopup({
    /// Email of the customer
    required String customerEmail,

    /// [amount] is should be multiplied by 100 [eg amount * 100]
    required String amount,

    /// Alpha numeric and/or number ID to a transaction
    required String reference,

    /// URL to redirect to after payment is successful, this helps close the session.
    /// This is setup in the Dashboard of paystack and the same URL setup is then provided here by you again.
    /// [callBackUrl] is required for mobile only
    String? callBackUrl,

    /// [publicKey] is required for web only
    String? publicKey,

    /// [secretKey] is required for android and iOS when you want the package to
    /// initialize and verify the transaction internally.
    /// Omit this if you are initializing the transaction on your own server and
    /// passing the resulting URL via [authorizationUrl].
    String? secretKey,

    /// Pre-generated Paystack authorization URL from your own server.
    /// When provided on mobile, the package skips the internal
    /// `/transaction/initialize` call. The [onSuccess] callback will still
    /// fire once the webview flow completes, so you can trigger your own
    /// server-side verification from there.
    /// Either [secretKey] or [authorizationUrl] must be supplied for mobile.
    String? authorizationUrl,

    /// Currency of the transaction
    String? currency,

    /// [context] is required for android and iOS only
    BuildContext? context,

    /// Incase your payment was setup with a subscription pattern/plan
    String? plan,

    ///Extra data for developer purposes.
    Map? metadata,

    /// [onClosed] is called when the user cancels a transaction or when there is a failed transaction
    required Function() onClosed,

    /// [onSuccess] is called on successfull transactions
    required Function() onSuccess,
  }) async {
    final MakePlatformSpecificPayment makePlatformSpecificPayment =
        MakePlatformSpecificPayment();
    if (kIsWeb) {
      //because public key is needed for web
      if (publicKey == null) {
        throw Exception('Please provide your paystack public key');
      } else if (publicKey.isEmpty) {
        throw Exception('Please provide a valid paystack public key');
      }
    } else {
      // Running on mobile.
      if (context == null) {
        throw Exception('Pass down your BuildContext');
      }
      // At least one of secretKey or authorizationUrl must be supplied.
      final hasSecretKey = secretKey != null && secretKey.isNotEmpty;
      final hasAuthUrl =
          authorizationUrl != null && authorizationUrl.isNotEmpty;
      if (!hasSecretKey && !hasAuthUrl) {
        throw Exception(
            'Please provide either your Paystack secret key (for internal '
            'initialization + verification) or a pre-generated '
            'authorizationUrl from your server.');
      }
    }

    final cancelMetaData = {"cancel_action": "cancelurl.com"};
    if (metadata == null) {
      metadata = cancelMetaData;
    } else {
      metadata.addEntries(cancelMetaData.entries);
    }

    return await makePlatformSpecificPayment.makePayment(
      customerEmail: customerEmail,
      context: context,
      currency: currency,
      publicKey: publicKey,
      secretKey: secretKey,
      authorizationUrl: authorizationUrl,
      amount: amount,
      metadata: metadata,
      plan: plan,
      reference: reference,
      onClosed: onClosed,
      onSuccess: onSuccess,
      callBackUrl: callBackUrl,
    );
  }
}
