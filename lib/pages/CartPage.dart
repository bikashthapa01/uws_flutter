import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uws/model/Cart.dart';
import 'package:uws/widgets/BootstrapContainer.dart';

import '../widgets/CartProduct.dart';
import '../widgets/CustomAppBar.dart'; // Import your Cart model

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'UWS',),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BootstrapContainer(
              child:  Padding(
                padding: EdgeInsets.only(top: 64.0,left: 16,right: 16,bottom: 16),
                child: Text("Your Cart",style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),
            Consumer<Cart>(
              builder: (ctx, cart, _) {
                if (cart.itemCount == 0) {
                  return const Center(child: Text('Your cart is empty.'));
                }
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cart.itemCount,
                  itemBuilder: (ctx, index) {
                    var cartItem = cart.items.values.toList()[index];
                    return BootstrapContainer(child: CartProduct(cartItem:cartItem));
                  },
                );
              },
            ),
            Consumer<Cart>(
              builder: (ctx, cart, _) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: BootstrapContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total: \$${cart.totalAmount.toStringAsFixed(2)}",style: const TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff198754)),
                        onPressed: () {
                          // Navigate to checkout page
                          Navigator.pushNamed(context, "/checkout");
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text('Proceed to Checkout',style: TextStyle(fontSize: 18),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
