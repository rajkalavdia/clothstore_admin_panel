import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  static const String routeName = "/OrderDetails";

  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [],
        ),
      ),
    );
  }

  Widget getHeader() {
    return Row(
      children: [],
    );
  }
}
