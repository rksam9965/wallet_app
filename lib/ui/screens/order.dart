// lib/screens/order_screen.dart
import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../features/widgets/ordertiles.dart';

class OrderBookPage extends StatefulWidget {
  @override
  _OrderBookPageState createState() => _OrderBookPageState();
}

class _OrderBookPageState extends State<OrderBookPage> {
  final List<Order> buyOrders = [
    Order(price: 100.50, quantity: 2.5),
    Order(price: 100.00, quantity: 1.8),
    Order(price: 99.75, quantity: 3.2),
    Order(price: 99.50, quantity: 4.0),
  ];

  final List<Order> sellOrders = [
    Order(price: 101.00, quantity: 2.0),
    Order(price: 101.50, quantity: 1.5),
    Order(price: 102.00, quantity: 2.0),
    Order(price: 102.50, quantity: 1.0),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffECF5FD),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 80,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Orders",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
          
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // BUY button
                          ActionButton(label: 'BUY',color:Colors.green),
                          const SizedBox(width: 10),
                          // SELL button
                          ActionButton(label: 'SELL',color:Colors.redAccent),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.green, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...buyOrders.map((order) {
                                    return OrderTile(order: order, isBuy: true);
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          // Sell Orders Column
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.red, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...sellOrders.map((order) {
                                    return OrderTile(order: order, isBuy: false);
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  Color? color;

   ActionButton({required this.label, this. color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      decoration: BoxDecoration(
        // color: color?.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     spreadRadius: 2,
        //     blurRadius: 3,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Center(
        child: Text(
          label,
          style:  TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
