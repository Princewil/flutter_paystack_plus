import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';

import 'non_web_pay_compnt.dart';

class PayForMobile implements MakePlatformSpecificPayment {
  @override
  Future makePayment({
    required String customerEmail,
    required String amount,
    required String reference,
    String? callBackUrl,
    String? publicKey,
    String? secretKey,
    String? currency,
    String? plan,
    String? authorizationUrl,
    BuildContext? context,
    Map? metadata,
    required Function() onClosed,
    required Function() onSuccess,
  }) async {
    return await Navigator.push(
      context!,
      MaterialPageRoute(
          builder: (context) => PaystackPayNow(
                secretKey: secretKey,
                email: customerEmail,
                reference: reference,
                currency: currency ?? 'NGN',
                amount: amount,
                plan: plan ?? '',
                metadata: metadata,
                transactionCompleted: onSuccess,
                transactionNotCompleted: onClosed,
                callbackUrl: callBackUrl ?? '',
                authorizationUrl: authorizationUrl,
              )),
    );
  }
}

MakePlatformSpecificPayment makePlatformSpecificPayment() => PayForMobile();
