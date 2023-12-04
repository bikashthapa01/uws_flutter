import 'package:flutter/material.dart';

class ShowMessage extends StatelessWidget {
  final String message;
  final bool success;
  const ShowMessage({super.key, required this.message, required this.success});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: success ? Colors.blue[100] : Colors.red, // Light blue color similar to 'alert-info'
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(width: 1,color: Colors.lightBlue)
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.black54, // Dark blue color for the text
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
