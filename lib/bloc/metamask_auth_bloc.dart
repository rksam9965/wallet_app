import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/bloc/wallet_event.dart';
import 'package:wallet_app/bloc/wallet_state.dart';

import 'package:walletconnect_flutter_v2/apis/sign_api/models/session_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/sign_client_models.dart';
import 'package:walletconnect_flutter_v2/apis/utils/namespace_utils.dart';

import '../services/services.dart';
import '../utils/constants/app_constants.dart';

class MetaMaskAuthBloc extends Bloc<WalletEvent, WalletState> {
  MetaMaskAuthBloc() : super(WalletInitialState()) {
    on<MetamaskAuthEvent>((event, emit) async {
      try {


        emit(WalletInitializedState(message: AppConstants.initializing));



        bool isInitialize = await walletConnectorService.initialize();
        if (!isInitialize) {
          emit(WalletErrorState(message: AppConstants.walletConnectError));
          return;
        }

        emit(WalletInitializedState(message: AppConstants.initialized));

        ConnectResponse? resp = await walletConnectorService.connect();
        if (resp == null || resp.uri == null) {
          emit(WalletErrorState(message: AppConstants.walletConnectError));
          return;
        }

        bool canLaunch = await walletConnectorService.onDisplayUri(resp.uri);
        if (!canLaunch) {
          emit(WalletErrorState(message: AppConstants.metamaskNotInstalled));
          return;
        }

        SessionData? sessionData = await walletConnectorService.authorize(
          resp,
          event.signatureFromBackend,
        );

        if (sessionData == null) {
          emit(WalletErrorState(
              message: AppConstants.userDeniedConnectionRequest));
          return;
        }

        String walletAddress = NamespaceUtils.getAccount(
            sessionData.namespaces.values.first.accounts.first);

        final String? signatureFromWallet =
        await walletConnectorService.sendMessageForSigned(
          resp,
          walletAddress,
          sessionData.topic,
          event.signatureFromBackend,
        );

        if (signatureFromWallet == null || signatureFromWallet.isEmpty) {
          emit(WalletErrorState(
              message: AppConstants.userDeniedMessageSignature));
          return;
        }



        emit(WalletReceivedSignatureState(
          signatureFromWallet: signatureFromWallet,
          signatureFromBk: event.signatureFromBackend,
          walletAddress: walletAddress,
          message: AppConstants.connectionSuccessful,
        ));

        // await walletConnectorService.disconnectWallet(topic: sessionData.topic);
      } catch (e) {
        emit(WalletErrorState(message: AppConstants.walletConnectError));
      }
    });
  }
}
