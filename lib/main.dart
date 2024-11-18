import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_app/services/services.dart';
import 'package:wallet_app/ui/features/bottom_navigation.dart';
import 'package:wallet_app/ui/features/splash_screen.dart';
import 'package:wallet_app/ui/screens/profile.dart';

import 'bloc/metamask_auth_bloc.dart';
import 'ui/screens/order.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices(); // Ensure services are initialized

  // Check SharedPreferences for wallet connection
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isWalletConnected = prefs.getBool('isWalletConnected') ?? false;

  // Set the default screen based on the wallet connection status
  Widget defaultScreen = isWalletConnected ? BottomNavigation() : SplashScreen();

  runApp(MyApp(defaultScreen: defaultScreen));
}

class MyApp extends StatelessWidget {
  final Widget defaultScreen;

  const MyApp({super.key, required this.defaultScreen});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MetaMaskAuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MetaMask Wallet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // Set the initial route dynamically based on `defaultScreen`
        initialRoute: defaultScreen == BottomNavigation() ? '/bottomNavigation' : '/splashScreen',
        routes: {
          '/splashScreen': (context) => SplashScreen(),
          '/bottomNavigation': (context) => BottomNavigation(),
          '/profileScreen': (context) => ProfileScreen(),
          // Add other routes here
        },
      ),
    );
  }
}
