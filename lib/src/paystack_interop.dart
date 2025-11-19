

import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';
// import 'package:js/js.dart';
import 'dart:js_interop';
// 'dart:js' is deprecated and shouldn't be used. Use dart:js_interop instead.
// Try replacing the use of the deprecated member with the replacement.

@JS()
external void paystackPopUp(
  JSString publicKey,
  JSString email,
  JSString amount,
  JSString ref,
  JSString plan,
  JSString currency,
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
        publicKey!.toJS,
        customerEmail.toJS,
        amount.toJS,
        reference.toJS,
        (plan ?? '').toJS,
        (currency ?? 'NGN').toJS,
        onClosed.toJS,
        onSuccess.toJS,
        );
     
  }
}

MakePlatformSpecificPayment makePlatformSpecificPayment() => PayForWeb();
