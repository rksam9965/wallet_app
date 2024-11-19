import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_app/ui/screens/recent.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../features/widgets/total_wallet_bal.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String walletBalance = "\$0.00";
  String ethBalance = "0.0 ETH";
  String walletAddress = "";
  double percentageChange = 0.0; // To store the percentage change
  double currentEthPrice = 0.0; // To store the current Ethereum price in USD
  double previousEthPrice = 0.0; // To store the previous Ethereum price for calculation

  final String _rpcUrl = "https://mainnet.infura.io/v3/84769203b26745968db90650b1220871";
  late Web3Client _web3Client;

  @override
  void initState() {
    _web3Client = Web3Client(_rpcUrl, Client());
    _fetchWalletData();
    _fetchEthereumPrice();
    super.initState();
  }


  // Fetch Wallet Data (Balance, Address)
  Future<void> _fetchWalletData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = prefs.getString('signature') ?? 'Not Connected';

    if (address == 'Not Connected') {
      setState(() {
        walletAddress = address;
      });
      return;
    }

    setState(() {
      walletAddress = address;
    });

    EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    EtherAmount balance = await _web3Client.getBalance(ethAddress);

    setState(() {
      ethBalance = "${balance.getValueInUnit(EtherUnit.ether).toStringAsFixed(4)} ETH";
    });

    setState(() {
      walletBalance = "\$${(balance.getValueInUnit(EtherUnit.ether) * currentEthPrice).toStringAsFixed(2)}"; // Use the fetched ETH price for balance
    });
  }

  // Fetch Ethereum price from CoinGecko API
  Future<void> _fetchEthereumPrice() async {
    try {
      final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double newPrice = data['ethereum']['usd'].toDouble();
        setState(() {
          currentEthPrice = newPrice;

          if (previousEthPrice != 0.0) {
            // Calculate percentage change based on the previous price
            percentageChange = ((currentEthPrice - previousEthPrice) / previousEthPrice) * 100;
          }

          previousEthPrice = currentEthPrice;  // Update previous ETH price for future comparison
        });
      } else {
        throw Exception('Failed to load Ethereum price');
      }
    } catch (e) {
      print("Error fetching Ethereum price: $e");
    }
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Are you sure you want to sign out?', textScaleFactor: 1),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              _logout();
            },
            child: const Text('Yes', style: TextStyle(color: Colors.black)),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            isDefaultAction: true,
            child: const Text('No', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/splashScreen');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffECF5FD),
        body: Column(
          children: [
            _myAppBar(MediaQuery.of(context).size.height),
            const SizedBox(height: 25),
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: TotalWalletBalance(
                      context: context,
                      walletAddress: walletAddress,
                      totalBalance: walletBalance,
                      crypto: ethBalance,
                      percentage: percentageChange, // Pass the percentage change
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      recentTransaction(
                        iconUrl: 'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency/128/Ethereum-icon.png',
                        percentage: percentageChange,
                        myCrypto: ethBalance,
                        balance: walletBalance,
                        profit: percentageChange >= 0
                            ? "+\$${(currentEthPrice * percentageChange / 100).toStringAsFixed(2)}"
                            : "-\$${(currentEthPrice * percentageChange / 100).toStringAsFixed(2)}",
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

  Widget _myAppBar(double screenHeight) {
    return Container(
      height: screenHeight * 0.1,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: showAlertDialog,
            child: const Icon(
              Icons.logout,
              color: Colors.black87,
            ),
          ),
          const Text(
            "Profile",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
