import 'package:js/js.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';

@JS()
external paystackPopUp(
  String publicKey,
  String email,
  String amount,
  String ref,
  void Function() onClosed,
  void Function() callback,
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
    BuildContext? context,
    required void Function() onClosed,
    required void Function() onSuccess,
  }) async {
    js.context.callMethod(
      paystackPopUp(
        publicKey!,
        customerEmail,
        amount,
        reference,
        js.allowInterop(onClosed),
        js.allowInterop(onSuccess),
      ),
      [],
    );
  }
}

MakePlatformSpecificPayment makePlatformSpecificPayment() => PayForWeb();
