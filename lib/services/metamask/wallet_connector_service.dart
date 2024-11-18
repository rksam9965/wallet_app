import 'package:walletconnect_flutter_v2/apis/sign_api/models/session_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/sign_client_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/sign_client.dart';

abstract class WalletConnectorService {
  SignClient get wClient;
  Future<bool> initialize();
  Future<ConnectResponse?> connect();
  Future<SessionData?> authorize(
    ConnectResponse resp,
    String unSignedMessage,
  );
  Future<String?> sendMessageForSigned(
    ConnectResponse resp,
    String walletAddress,
    String topic,
    String unSignedMessage,
  );
  Future<bool> onDisplayUri(Uri? uri);
  Future<void> disconnectWallet({required String topic});
}



