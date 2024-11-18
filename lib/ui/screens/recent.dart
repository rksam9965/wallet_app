import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class recentTransaction extends StatelessWidget {
  const recentTransaction({
    super.key,
    required this.iconUrl,
    required this.percentage,
    required this.myCrypto,
    required this.balance,
    required this.profit,
  });

  final String iconUrl;
  final double percentage;
  final String myCrypto;
  final balance;
  final profit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              iconUrl,
              width: 50,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    myCrypto,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    profit,
                    style:  const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$balance',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  percentage >= 0 ? '+$percentage%' : '$percentage%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: percentage >= 0 ? Colors.green : Colors.pink,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}