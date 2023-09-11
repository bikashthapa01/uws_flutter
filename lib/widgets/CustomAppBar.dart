import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uws/pages/HomePage.dart';

import '../model/Cart.dart';
import 'BootstrapContainer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(248, 249, 250, 1),
      elevation: 0,
      title: BootstrapContainer(
        child: InkWell(
          onTap: (){
            Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          },
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
        actions: [
          BootstrapContainer(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/cart");
                    },
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.black,
                  ),
                  Consumer<Cart>(
                    builder: (ctx, cart, _) => Text('${cart.itemCount}',style: const TextStyle(color: Colors.black),),
                  )
                ],
              ),)
        ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Default AppBar height
}
