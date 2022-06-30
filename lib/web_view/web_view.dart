import 'dart:async';                                    // Add this import

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';  // Add this import back

import 'navigation_controls.dart';                  // Add this import
import 'web_view_stack.dart';

class WebView extends StatefulWidget {
  const WebView({ Key? key }) : super(key: key);

  

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add from here ...
        actions: [
          NavigationControls(controller: controller),
        ],
        // ... to here.
      ),
      body: WebViewStack(controller: controller),       // Add the controller argument
    );
  }
}