// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'paystack_interop.dart';

class FlutterPaystackPlus {
  static Future<void> openPaystackPopup({
    required String publicKey,
    required String email,
    required String amount,
    required String ref,
    required void Function() onClosed,
    required void Function() onSuccess,
  }) async {
    js.context.callMethod(
      paystackPopUp(
        publicKey,
        email,
        amount,
        ref,
        js.allowInterop(onClosed),
        js.allowInterop(onSuccess),
      ),
      [],
    );
  }
}
