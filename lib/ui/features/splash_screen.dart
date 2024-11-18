import 'package:flutter/material.dart';
import 'package:metamask_login_blog/ui/features/metamask_login_screen.dart';
import 'package:metamask_login_blog/utils/constants/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2000), redirectUser);
  }

  Future<void> redirectUser() async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return const MetaMaskLoginScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Assets.nsLoader,
          width: 200,
        ),
      ),
    );
  }
}
