import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_app/ui/features/widgets/custom/nsalert_dialog.dart';
import 'package:wallet_app/ui/features/widgets/custom/other_custom_widgets.dart';
import 'package:wallet_app/ui/features/widgets/custom/show_snack_bar.dart';
import '../../bloc/metamask_auth_bloc.dart';
import '../../bloc/wallet_event.dart';
import '../../bloc/wallet_state.dart';
import 'bottom_navigation.dart';

class MetaMaskLoginScreen extends StatefulWidget {
  const MetaMaskLoginScreen({super.key});

  @override
  State<MetaMaskLoginScreen> createState() => _MetaMaskLoginScreenState();
}

class _MetaMaskLoginScreenState extends State<MetaMaskLoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  BuildContext? dialogContext;
  final String signatureFromBackend = "NonStop IO Technologies Pvt Ltd.";

  @override
  Widget build(BuildContext context) {
    return BlocListener<MetaMaskAuthBloc, WalletState>(
      listener: (context, state) async {
        if (state is WalletErrorState) {
          hideDialog(dialogContext);
          ShowSnackBar.buildSnackbar(context, state.message, true);
        } else if (state is WalletReceivedSignatureState) {
          // Hide loading dialog and show success message
          hideDialog(dialogContext);
          ShowSnackBar.buildSnackbar(context, state.message.toString());

          // Save wallet connection status and other details in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isWalletConnected', true); // Flag for wallet connection
          await prefs.setString('signature', state.walletAddress); // Save signature if needed
          await prefs.setString('yy', state.signatureFromWallet); // Save signature if needed


          // Navigate to HomeScreen (with Bottom Navigation Bar)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation()),
          );
        }
      },

      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Center(
            child: InkWell(
              onTap: () {
                BlocProvider.of<MetaMaskAuthBloc>(context).add(
                  MetamaskAuthEvent(signatureFromBackend: signatureFromBackend),
                );
                buildShowDialog(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0), // Add padding for button size
                decoration: BoxDecoration(
                  color: Colors.blue, // Blue background color
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                child: const Text(
                  "Connect", // Button text
                  style: TextStyle(
                    color: Colors.white, // White text color
                    fontSize: 16.0, // Font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),
            ),
          )
        ),
      ),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: _scaffoldKey.currentContext ?? context,
        barrierDismissible: true,
        builder: (BuildContext dialogContextL) {
          dialogContext = dialogContextL;
          return BlocBuilder<MetaMaskAuthBloc, WalletState>(
              builder: (context, state) {
                return NSAlertDialog(
                  textWidget: getText(state),
                );
              });
        });
  }

  getText(WalletState state) {
    String message = "";
    if (state is WalletInitializedState) {
      message = state.message;
    } else if (state is WalletAuthorizedState) {
      message = state.message;
    } else if (state is WalletReceivedSignatureState) {
      message = state.message;
    }
    return Text(
      message,
      style: const TextStyle(fontSize: 18, color: Colors.white),
    );
  }
}
