import 'package:js/js.dart';

@JS()
external paystackPopUp(
  String publicKey,
  String email,
  String amount,
  String ref,
  void Function() onClosed,
  void Function() callback,
);
