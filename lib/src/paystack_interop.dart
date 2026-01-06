import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';
import 'dart:js_interop';

@JS('paystackPopUp')
external void paystackPopUp(
  String publicKey,
  String email,
  String amount,
  String ref,
  String plan,
  String currency,
  JSFunction onClosed,
  JSFunction callback,
);

class PayForWeb implements MakePlatformSpecificPayment {
  @override
  makePayment({
    required String customerEmail,
    required String amount,
    required String reference,
    String? callBackUrl,
    String? publicKey,
    String? secretKey,
    String? currency,
    metadata,
    String? plan,
    BuildContext? context,
    required void Function() onClosed,
    required void Function() onSuccess,
  }) async {
    paystackPopUp(
      publicKey!,
      customerEmail,
      amount,
      reference,
      plan ?? '',
      currency ?? 'NGN',
      onClosed.toJS,
      onSuccess.toJS,
    );
  }
}

MakePlatformSpecificPayment makePlatformSpecificPayment() => PayForWeb();
