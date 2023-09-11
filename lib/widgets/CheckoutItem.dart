import 'package:flutter/material.dart';

class CheckoutItem extends StatelessWidget {
  final String title;
  final double price;
  final int quantity;
  const CheckoutItem({super.key, required this.title, required this.price, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("$title - \$$price x $quantity",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
        const SizedBox(height: 10),
      ],
    );
  }
}
