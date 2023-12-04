import 'dart:convert';
import 'dart:math';

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

  final int count = 20000;

  @override
  void initState() {
    super.initState();
    // Record start time
    final startTime = DateTime.now().millisecondsSinceEpoch;
    futureProducts = loadProductsFromAssets(count);

    futureProducts.then((productResponse) {
      // Record end time after loading and rendering
      final endTime = DateTime.now().millisecondsSinceEpoch;

      // Calculate time taken in milliseconds
      final loadingTime = endTime - startTime;
      print('Time taken to load and render ${count} products: $loadingTime ms');
    });
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

  Future<ProductResponse> loadProductsFromAssets(int count) async {
    String jsonString = await rootBundle.loadString('assets/products.json');
    final jsonResponse = json.decode(jsonString);

    List<Map<String, dynamic>> originalProducts = List.from(jsonResponse['products']);
    List<Map<String, dynamic>> randomProducts = [];

    // Generate unique IDs for the new products and randomize the selection
    Set<int> usedIds = Set();
    Random random = Random();

    while (randomProducts.length < count) {
      int randomIndex = random.nextInt(originalProducts.length);
      Map<String, dynamic> originalProduct = originalProducts[randomIndex];

      // Ensure unique IDs
      int newId = originalProduct['id'];
      while (usedIds.contains(newId)) {
        newId = random.nextInt(50000) + 1; // Adjust this range based on your requirements
      }
      usedIds.add(newId);

      // Create a new product with a unique ID
      Map<String, dynamic> newProduct = {
        ...originalProduct,
        'id': newId,
      };

      randomProducts.add(newProduct);
    }

    // Update the JSON response with the randomly generated products
    jsonResponse['products'] = randomProducts;

    return ProductResponse.fromJson(jsonResponse);
  }
}
