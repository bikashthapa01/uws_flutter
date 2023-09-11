import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uws/model/Cart.dart';
import 'package:uws/widgets/BootstrapContainer.dart';
import 'package:uws/widgets/CheckoutItem.dart';
import 'package:uws/widgets/CustomAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  bool _orderPlaced = false;

  // Sample fields for the shipping form
  String _name = '';
  String _address = '';
  String _city = '';
  String _country = '';
  String _zip = '';

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context, listen: false);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: const CustomAppBar(title: "UWS"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BootstrapContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Checkout',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text('Order Summary',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Consumer<Cart>(
                      builder: (context, cart, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: cart.items.values.map((cartItem) {
                            return CheckoutItem(
                                title: cartItem.product.title,
                                price: cartItem.product.price,
                                quantity: cartItem.quantity);
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<Cart>(
                      builder: (context, cart, child) {
                        return Text(
                          'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Shipping Details Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Shipping Details',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Name",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Address",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _address = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "City",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your City';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _city = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Country",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Country';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _country = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Zip Code",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Zip Code';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _zip = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _orderPlaced ? (){
                          Navigator.pushNamed(context, "/");
                        }  : () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // Here, you can send the data to the server or save it locally.

                            try {
                              // Sign in the user anonymously
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInAnonymously();

                              List<Map<String, dynamic>> cartItemsMap = cartItems.map((cartItem) {
                                return {
                                  'productId': cartItem.product.id,
                                  'title': cartItem.product.title,
                                  'quantity': cartItem.quantity,
                                  'price': cartItem.product.price,
                                  // Add any other fields from CartItem that you want to store
                                };
                              }).toList();

                              // Save the order details to Firestore
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .add({
                                'name': _name,
                                'address': _address,
                                'city': _city,
                                'country': _country,
                                'zip': _zip,
                                'userId': userCredential.user!.uid,
                                "cart":cartItemsMap,
                                "total":cart.totalAmount.toStringAsFixed(2),
                                // Store the user's ID with the order for reference
                              });

                              // Sign out the user
                              await FirebaseAuth.instance.signOut();

                              setState(() {
                                _orderPlaced = true;
                              });

                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Order Placed Successfully')),
                              );

                              cart.clearCart();

                            } catch (e) {
                              // Handle the error (e.g., show an error message)

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('An error occurred: $e')),
                              );
                            }
                          }
                        },
                        child: _orderPlaced ? const Text("Go To Home") : const Text('Finish'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
