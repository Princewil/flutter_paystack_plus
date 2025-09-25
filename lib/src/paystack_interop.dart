// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
//import 'dart:js_interop' as js;

import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';
// import 'package:js/js.dart';
import 'dart:js_interop';
// 'dart:js' is deprecated and shouldn't be used. Use dart:js_interop instead.
// Try replacing the use of the deprecated member with the replacement.

@JS()
external paystackPopUp(
  String publicKey,
  String email,
  String amount,
  String ref,
  String plan,
  String currency,
  Function() onClosed,
  Function() callback,
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
    required Function() onClosed,
    required Function() onSuccess,
  }) async {
    js.context.callMethod(
      paystackPopUp(
        publicKey!,
        customerEmail,
        amount,
        reference,
        plan ?? '',
        currency ?? 'NGN',
        js.allowInterop(onClosed),
        js.allowInterop(onSuccess),
      ),
      [],
    );
  }
}

MakePlatformSpecificPayment makePlatformSpecificPayment() => PayForWeb();
