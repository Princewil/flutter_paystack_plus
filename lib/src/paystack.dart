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

    /// [secretKey] is required for android and iOS only
    String? secretKey,

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
      //meaning its running on mobile
      if (context == null) {
        //because context is needed for mobile
        throw Exception('Pass down your BuildContext');
      } else if (secretKey == null) {
        //because Secret key is needed for mobile
        throw Exception('Please provide your paystack secret key');
      } else if (secretKey.isEmpty) {
        throw Exception('Please provide a valid paystack secret key');
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
