import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uws/widgets/BootstrapContainer.dart';
import 'package:uws/widgets/CustomAppBar.dart';

import '../model/Product.dart';
import '../widgets/ProductWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<ProductResponse> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = loadProductsFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double width = MediaQuery.of(context).size.width;

    // Adjust the number of products per row based on screen width
    int crossAxisCount = width < 700
        ? 1
        : width < 1000
            ? 2
            : 3;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'UWS'
      ),
      body: FutureBuilder<ProductResponse>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final products = snapshot.data!.products;

            return BootstrapContainer(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                  children: products
                      .map((product) => ProductWidget(product: product))
                      .toList(),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<ProductResponse> loadProductsFromAssets() async {
    String jsonString = await rootBundle.loadString('assets/products.json');
    final jsonResponse = json.decode(jsonString);
    return ProductResponse.fromJson(jsonResponse);
  }
}
