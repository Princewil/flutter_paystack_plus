import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';

/// [publicKey] is required for web only
/// [secretKey] is required for android and iOS only
/// [context] is required for android and iOS only
/// [amount] is should be multiplied by 100 [eg amount * 100]
/// [onClose] is called when the user cancels a transaction or when there is a failed transaction
/// [onSuccess] is called on successfull transactions
class FlutterPaystackPlus {
  static Future<void> openPaystackPopup({
    required String customerEmail,
    required String amount,
    required String reference,
    String? publicKey,
    String? secretKey,
    String? currency,
    BuildContext? context,
    required void Function() onClosed,
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
        onSuccess: onSuccess);
    // if (kIsWeb) {
    //   return await forWeb(
    //     publicKey: publicKey!,
    //     email: customerEmail,
    //     amount: amount,
    //     ref: reference,
    //     onClosed: onClosed,
    //     onSuccess: onSuccess,
    //   );
    // } else {
    //   return await forNonWeb(
    //       customerEmail: customerEmail,
    //       amount: amount,
    //       reference: reference,
    //       secretKey: secretKey!,
    //       currency: currency ?? 'NGN',
    //       context: context!,
    //       onClosed: onClosed,
    //       onSuccess: onSuccess);
    // }
  }
}
