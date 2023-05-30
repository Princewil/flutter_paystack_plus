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

    /// [publicKey] is required for web only
    String? publicKey,

    /// [secretKey] is required for android and iOS only
    String? secretKey,

    /// Currency of the transaction
    String? currency,

    /// [context] is required for android and iOS only
    BuildContext? context,

    /// [onClosed] is called when the user cancels a transaction or when there is a failed transaction
    required void Function() onClosed,

    /// [onSuccess] is called on successfull transactions
    required void Function() onSuccess,
  }) async {
    final MakePlatformSpecificPayment makePlatformSpecificPayment =
        MakePlatformSpecificPayment();
    return await makePlatformSpecificPayment.makePayment(
      customerEmail: customerEmail,
      context: context,
      currency: currency,
      publicKey: publicKey,
      secretKey: secretKey,
      amount: amount,
      reference: reference,
      onClosed: onClosed,
      onSuccess: onSuccess,
    );
  }
}
