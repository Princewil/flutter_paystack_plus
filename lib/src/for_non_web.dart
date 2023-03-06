import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';

Future forNonWeb({
  required String customerEmail,
  required String amount,
  required String reference,
  required String secretKey,
  required String currency,
  required BuildContext context,
  required void Function() onClosed,
  required void Function() onSuccess,
}) async {
  return await PayWithPayStack().now(
    context: context,
    secretKey: secretKey,
    customerEmail: customerEmail,
    reference: reference,
    currency: currency,
    amount: amount,
    transactionCompleted: onClosed,
    transactionNotCompleted: onSuccess,
  );
}
