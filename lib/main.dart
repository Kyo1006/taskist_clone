import 'package:flutter/material.dart';

import 'components/menu_bar.dart';
import 'theme_management/theme_manager.dart';
import 'package:provider/provider.dart';
// import 'myapp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) =>  MaterialApp(
        theme: theme.getTheme(),
        debugShowCheckedModeBanner: false,
        title: _title,
        home: const MenuBar(index: 0),
        
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'theme_manager.dart';
// import 'package:provider/provider.dart';

// void main() {
//   return runApp(ChangeNotifierProvider<ThemeNotifier>(
//     create: (_) => ThemeNotifier(),
//     child: const MyApp(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeNotifier>(
//         builder: (context, theme, child) => MaterialApp(
//               theme: theme.getTheme(),
//               home: Scaffold(
//                 appBar: AppBar(
//                   title: Text('Hybrid Theme'),
//                 ),
//                 body: Row(
//                   children: [
//                     FlatButton(
//                       onPressed: () => {
//                         theme.setLightMode(),
//                       },
//                       child: const Text('Set Light Theme'),
//                     ),
//                     FlatButton(
//                       onPressed: () => {
//                         theme.setDarkMode(),
//                       },
//                       child: const Text('Set Dark theme'),
//                     ),
//                   ],
//                 ),
//               ),
//             ));
//   }
// }

// import 'dart:async';                                    // Add this import

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';  // Add this import back

// import 'navigation_controls.dart';                  // Add this import
// import 'web_view_stack.dart';

// void main() {
//   runApp(
//     const MaterialApp(
//       home: WebViewApp(),
//     ),
//   );
// }

// class WebViewApp extends StatefulWidget {
//   const WebViewApp({Key? key}) : super(key: key);

//   @override
//   State<WebViewApp> createState() => _WebViewAppState();
// }

// class _WebViewAppState extends State<WebViewApp> {
//   final controller = Completer<WebViewController>();    // Instantiate the controller

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter WebView'),
//         // Add from here ...
//         actions: [
//           NavigationControls(controller: controller),
//         ],
//         // ... to here.
//       ),
//       body: WebViewStack(controller: controller),       // Add the controller argument
//     );
//   }
// }