// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PaystackPayNow extends StatefulWidget {
  /// Secret key is optional. When provided, the package will initialize the
  /// transaction and verify it internally. When null, [authorizationUrl] must
  /// be supplied (pre-generated from your server) and the [transactionCompleted]
  /// callback fires as soon as the webview flow ends — leaving verification
  /// entirely to your server.
  final String? secretKey;
  final String reference;
  final String callbackUrl;
  final String currency;
  final String email;
  final String amount;
  final String? plan;
  final metadata;
  final paymentChannel;
  final Function() transactionCompleted;
  final Function() transactionNotCompleted;

  /// Pre-generated authorization URL from your own server. When provided,
  /// the package skips the internal `/transaction/initialize` call. Requires
  /// [secretKey] to be null (or omitted) when you want full server-side flow.
  final String? authorizationUrl;

  const PaystackPayNow({
    Key? key,
    this.secretKey,
    required this.email,
    required this.reference,
    required this.currency,
    required this.amount,
    required this.callbackUrl,
    required this.transactionCompleted,
    required this.transactionNotCompleted,
    this.metadata,
    this.plan,
    this.paymentChannel,
    this.authorizationUrl,
  }) : super(key: key);

  @override
  State<PaystackPayNow> createState() => _PaystackPayNowState();
}

class _PaystackPayNowState extends State<PaystackPayNow> {
  late Future<PaystackRequestResponse> payment;
  WebViewController? _controller; // keep it persistent

  @override
  void initState() {
    super.initState();
    payment = _resolveAuthorizationUrl();
  }

  /// Returns the authorization URL either from the pre-supplied [authorizationUrl]
  /// or by initializing a transaction with Paystack using the [secretKey].
  Future<PaystackRequestResponse> _resolveAuthorizationUrl() async {
    // If a pre-generated URL was passed, use it directly — no network call needed.
    if (widget.authorizationUrl != null &&
        widget.authorizationUrl!.isNotEmpty) {
      return PaystackRequestResponse(
        authUrl: widget.authorizationUrl!,
        status: true,
        reference: widget.reference,
      );
    }
    return await _makePaymentRequest();
  }

  /// Makes HTTP Request to Paystack to initialize a transaction and get the
  /// authorization URL. Requires [secretKey] to be set.
  Future<PaystackRequestResponse> _makePaymentRequest() async {
    http.Response? response;
    try {
      /// Sending Data to paystack.
      response = await http.post(
        /// Url to send data to
        Uri.parse('https://api.paystack.co/transaction/initialize'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.secretKey}',
        },

        /// Data to send to the URL.
        body: jsonEncode({
          "email": widget.email,
          "amount": widget.amount,
          "reference": widget.reference,
          "currency": widget.currency,
          "plan": widget.plan,
          "metadata": widget.metadata,
          "callback_url": widget.callbackUrl,
          "channels": widget.paymentChannel
        }),
      );
    } on Exception catch (e) {
      /// In the event of an exception, take the user back and show a SnackBar error.
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        var snackBar =
            SnackBar(content: Text("Fatal error occurred, ${e.toString()}"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    if (response != null && response.statusCode == 200) {
      return PaystackRequestResponse.fromJson(jsonDecode(response.body));
    } else {
      final code = response?.statusCode ?? 500;
      final body = response?.body ?? 'Network error';
      throw Exception("Response Code: $code, Response Body: $body");
    }
  }

  WebViewController _buildController(String authUrl) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // remove the forced UA (let WebView pick a mobile UA)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.contains('cancelurl.com') ||
                url.contains('paystack.co/close')) {
              if (context.mounted) Navigator.of(context).pop();
              widget.transactionNotCompleted();
              return NavigationDecision.prevent;
            }

            if (widget.callbackUrl.isNotEmpty &&
                url.contains(widget.callbackUrl)) {
              if (context.mounted) Navigator.of(context).pop();
              _checkTransactionStatus(widget.reference);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(authUrl));

    return controller;
  }

  /// Checks for transaction status of current transaction before or after view closes.
  ///
  /// When [secretKey] is null, this step is skipped and [transactionCompleted]
  /// is called immediately — allowing the caller's server to handle verification.
  Future<void> _checkTransactionStatus(String ref) async {
    // No secret key → skip internal verification, fire success callback so the
    // caller can verify the transaction on their own server.
    if (widget.secretKey == null || widget.secretKey!.isEmpty) {
      widget.transactionCompleted();
      return;
    }

    try {
      /// Getting data, passing [ref] as a value to the URL that is being requested.
      final response = await http.get(
        Uri.parse('https://api.paystack.co/transaction/verify/$ref'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.secretKey}',
        },
      );

      if (response.statusCode == 200) {
        var decodedRespBody = jsonDecode(response.body);
        if (decodedRespBody["data"] != null &&
            (decodedRespBody["data"]["gateway_response"] == "Approved" ||
                decodedRespBody["data"]["gateway_response"] == "Successful")) {
          widget.transactionCompleted();
        } else {
          widget.transactionNotCompleted();
        }
      } else {
        widget.transactionNotCompleted();
      }
    } catch (_) {
      widget.transactionNotCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<PaystackRequestResponse>(
          future: payment,
          builder: (context, AsyncSnapshot<PaystackRequestResponse> snapshot) {
            /// Show screen if snapshot has data and status is true.
            if (snapshot.hasData && snapshot.data!.status == true) {
              _controller ??= _buildController(snapshot.data!.authUrl);

              return WebViewWidget(
                key: const ValueKey("paystack-webview"), // stable key
                controller: _controller!,
              );
            }

            if (snapshot.hasError) {
              return Material(
                child: Center(
                  child: Text('${snapshot.error}'),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class PaystackRequestResponse {
  final bool status;
  final String authUrl;
  final String reference;

  const PaystackRequestResponse(
      {required this.authUrl, required this.status, required this.reference});

  factory PaystackRequestResponse.fromJson(Map<String, dynamic> json) {
    return PaystackRequestResponse(
      status: json['status'],
      authUrl: json['data']["authorization_url"],
      reference: json['data']["reference"],
    );
  }
}
