import 'package:flutter_paystack_plus/src/stub.dart'
    if (dart.library.js) 'package:flutter_paystack_plus/src/paystack_interop.dart'
    if (dart.library.io) 'package:flutter_paystack_plus/src/for_non_web.dart';
import 'package:flutter/material.dart';

abstract class MakePlatformSpecificPayment {
  makePayment({
    required String customerEmail,
    required String amount,
    required String reference,
    required String? publicKey,
    required String? secretKey,
    required String? currency,
    required String? callBackUrl,
    String? plan,
    required Map? metadata,
    required BuildContext? context,
    required Function() onClosed,
    required Function() onSuccess,
  }) async {
    //
  }
  factory MakePlatformSpecificPayment() => makePlatformSpecificPayment();
}
