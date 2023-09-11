import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uws/model/Product.dart';
import 'package:uws/widgets/BootstrapContainer.dart';
import 'package:uws/widgets/CustomAppBar.dart';

import '../model/Cart.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final TextEditingController _quantityController =
      TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "UWS",
      ),
      body: BootstrapContainer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Check if screen width is less than 800 pixels
            bool isSmallScreen = constraints.maxWidth < 800;

            // Use Column for small screens and Row for larger screens
            return isSmallScreen
                ? buildVerticalLayout(product)
                : buildHorizontalLayout(product);
          },
        ),
      ),
    );
  }

  Widget buildVerticalLayout(Product product) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: Image.network(
            product.thumbnail,
            fit: BoxFit.fill,
          ),
        ),
        buildDetails(product)
      ],
    );
  }

  Widget buildHorizontalLayout(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(64),
          child: Image.network(
            product.thumbnail,
            fit: BoxFit.fill,
          ),
        ),
        Expanded(child: buildDetails(product))
      ],
    );
  }

  Widget buildDetails(Product product) {
    return Padding(
      padding: const EdgeInsets.all(64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: const TextStyle(color: Colors.black, fontSize: 18),
            softWrap: true,
          ),
          const SizedBox(height: 16),
          Text(
            "Price: \$${product.price}",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Quantity:",
            style: TextStyle(fontSize: 16),
          ),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "1",
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    int quantity = int.tryParse(_quantityController.text) ?? 1;
                    for (int i = 0; i < quantity; i++) {
                      Provider.of<Cart>(context, listen: false).addItem(product);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                );
              }),
              Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/checkout");
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Checkout",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                );
              })
            ],
          )
        ],
      ),
    );
  }
}
