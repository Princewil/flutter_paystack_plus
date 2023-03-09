// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';

import 'paystack_interop.dart';

class PayForWeb implements MakePlatformSpecificPayment {
  @override
  Future makePayment({
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
    return js.context.callMethod(
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

// // ignore_for_file: avoid_web_libraries_in_flutter
// import 'dart:js' as js;
// import 'paystack_interop.dart';

// Future forWeb({
//   required String publicKey,
//   required String email,
//   required String amount,
//   required String ref,
//   required void Function() onClosed,
//   required void Function() onSuccess,
// }) async {
//   js.context.callMethod(
//     paystackPopUp(
//       publicKey,
//       email,
//       amount,
//       ref,
//       js.allowInterop(onClosed),
//       js.allowInterop(onSuccess),
//     ),
//     [],
//   );
// }
