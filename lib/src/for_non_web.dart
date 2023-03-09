import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/src/abstract_class.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';

class PayForNonWeb implements MakePlatformSpecificPayment {
  @override
  Future makePayment(
      {required String customerEmail,
      required String amount,
      required String reference,
      String? publicKey,
      String? secretKey,
      String? currency,
      BuildContext? context,
      required void Function() onClosed,
      required void Function() onSuccess}) async {
    return await PayWithPayStack().now(
      context: context!,
      secretKey: secretKey!,
      customerEmail: customerEmail,
      reference: reference,
      currency: currency!,
      amount: amount,
      transactionCompleted: onClosed,
      transactionNotCompleted: onSuccess,
    );
  }
}

MakePlatformSpecificPayment makePlatformSpecificPayment() => PayForNonWeb();



// import 'package:flutter/material.dart';
// import 'package:pay_with_paystack/pay_with_paystack.dart';

// Future forNonWeb({
//   required String customerEmail,
//   required String amount,
//   required String reference,
//   required String secretKey,
//   required String currency,
//   required BuildContext context,
//   required void Function() onClosed,
//   required void Function() onSuccess,
// }) async {
//   return await PayWithPayStack().now(
//     context: context,
//     secretKey: secretKey,
//     customerEmail: customerEmail,
//     reference: reference,
//     currency: currency,
//     amount: amount,
//     transactionCompleted: onClosed,
//     transactionNotCompleted: onSuccess,
//   );
// }
