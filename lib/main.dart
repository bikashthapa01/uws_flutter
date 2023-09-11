import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uws/model/Cart.dart';
import 'package:uws/pages/CartPage.dart';
import 'package:uws/pages/CheckoutPage.dart';
import 'package:uws/pages/HomePage.dart';

import 'firebase_options.dart';
import 'pages/ProductDetailsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => Cart())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UWS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/cart": (context) =>  const CartPage(),
        "/product": (context) => const ProductDetailsPage(),
        "/checkout":(context) =>  const CheckoutPage(),
      },
    );
  }
}
