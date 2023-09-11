import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uws/model/CartItem.dart';

import '../model/Cart.dart';

class CartProduct extends StatelessWidget {
  final CartItem cartItem;

  const CartProduct({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1,color: Colors.black12)
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            SizedBox(
              height: 150,
              child: Image.network(
                cartItem.product.thumbnail,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      cartItem.product.description,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Price: \$${cartItem.product.price}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(onPressed: (){
                          if (cartItem.quantity > 1) {
                            cartItem.quantity -= 1;
                            Provider.of<Cart>(context, listen: false).notifyListeners();
                          } else {
                            Provider.of<Cart>(context, listen: false).removeItem(cartItem.product.id);
                          }
                        }, child: const Icon(Icons.remove)),
                        Text("${cartItem.quantity}"),
                        ElevatedButton(onPressed: () {
                          cartItem.quantity += 1;
                          Provider.of<Cart>(context, listen: false).notifyListeners();
                        }, child: const Icon(Icons.add)),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    ElevatedButton(onPressed: () => Provider.of<Cart>(context, listen: false).removeItem(cartItem.product.id),style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("Remove",style: TextStyle(fontSize: 18,),),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
