import 'package:flutter/material.dart';

class TotalWalletBalance extends StatelessWidget {
   TotalWalletBalance({
    super.key,
    required this.context,
    required this.totalBalance,
    required this.crypto,
     required this.walletAddress,  this.percentage,
  });

  final BuildContext context;
  final String totalBalance;
  final crypto;
  String walletAddress;
  double? percentage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        width: MediaQuery.of(context).size.width / 1.15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text("Wallet Address",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                 Container(
                   padding: const EdgeInsets.only(left: 5,right: 5),

                   height: 25,
                   decoration: const BoxDecoration(
                     color: Colors.blueAccent,
                     borderRadius: BorderRadius.all(
                       Radius.circular(5),
                     ),
                   ),
                   child: Expanded(
                    child: Center(
                      child: Text(  walletAddress,style: TextStyle(fontSize: 9,fontWeight:FontWeight.bold,color: Colors.white),
                      ),
                    ),
                                   ),
                 ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  totalBalance,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 38,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                // for increment decrement
              ],
            ),
            const SizedBox(height: 5),
            Text(
              '$crypto',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black26),
            )

          ],
        ),
      ),
    );
  }


}
