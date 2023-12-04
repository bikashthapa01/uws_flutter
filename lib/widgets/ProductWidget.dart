import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uws/model/Product.dart';

import '../model/Cart.dart';

class ProductWidget extends StatelessWidget {
  final Product product;

  const ProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Get screen width
        double width = MediaQuery.of(context).size.width;

        // Adjust sizes based on screen width
        double imageSize = width < 600 ? 150 : 200;
        double titleFontSize = width < 600 ? 18 : 20;
        double descriptionFontSize = width < 600 ? 14 : 16;

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: imageSize,
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: titleFontSize,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.description,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: descriptionFontSize,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Price: \$${product.price}"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Rating: ${product.rating}"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style:ElevatedButton.styleFrom(backgroundColor: const Color(0xff0d6efd)),
                      onPressed: () {
                        Provider.of<Cart>(context, listen: false).addItem(product);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Add To Cart",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/product",arguments: product);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6c757d),
                        elevation: 1,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "View",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
