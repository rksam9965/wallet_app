import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/order.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final bool isBuy;

  const OrderTile({required this.order, required this.isBuy});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color with transparency
            spreadRadius: 2, // How far the shadow spreads
            blurRadius: 3, // How blurry the shadow is
            offset: Offset(0, 4), // Position of the shadow (x, y)
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${order.price.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isBuy ? Colors.green : Colors.red),
            ),
            Text(
              '${order.quantity} BTC',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isBuy ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}