import 'package:flutter/material.dart';
import '/services/metamask/wallet_connector_service.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/apis/core/pairing/utils/pairing_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/json_rpc_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/proposal_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/session_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/sign_client_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/sign_client.dart';
import 'package:walletconnect_flutter_v2/apis/utils/errors.dart';

import '../../models/chain_metadata.dart';
import '../../utils/constants/wallet_constants.dart';
import '../../utils/helper/helper_functions.dart';

class MetamaskConnectorImpl implements WalletConnectorService {
  late SignClient _wcClient;
  final ChainMetadata _chainMetadata = WalletConstants.mainChainMetaData;
  @override
  SignClient get wClient => _wcClient;

  @override
  Future<bool> initialize() async {
    bool isInitialize = false;
    try {
      _wcClient = await SignClient.createInstance(
        relayUrl: _chainMetadata.relayUrl,
        projectId: _chainMetadata.projectId,
        metadata: PairingMetadata(
            name: "MetaMask",
            description: "MetaMask login",
            url: _chainMetadata.walletConnectUrl,
            icons: ["https://wagmi.sh/icon.png"],
            redirect: Redirect(universal: _chainMetadata.redirectUrl)),
      );
      isInitialize = true;
    } catch (err) {
      debugPrint("Catch wallet initialize error $err");
    }
    return isInitialize;
  }

  @override
  Future<ConnectResponse?> connect() async {
    try {
      ConnectResponse? resp = await wClient.connect(requiredNamespaces: {
        _chainMetadata.type: RequiredNamespace(
          chains: [_chainMetadata.chainId], // Ethereum chain
          methods: [_chainMetadata.method], // Requestable Methods
          events: _chainMetadata.events, // Requestable Events
        )
      });

      return resp;
    } catch (err) {
      debugPrint("Catch wallet connect error $err");
    }
    return null;
  }

  @override
  Future<SessionData?> authorize(
      ConnectResponse resp, String unSignedMessage) async {
    SessionData? sessionData;
    try {
      sessionData = await resp.session.future;
    } catch (err) {
      debugPrint("Catch wallet authorize error $err");
    }
    return sessionData;
  }

  @override
  Future<String?> sendMessageForSigned(ConnectResponse resp,
      String walletAddress, String topic, String unSignedMessage) async {
    String? signature;
    try {
      Uri? uri = resp.uri;
      if (uri != null) {
        // Now that you have a session, you can request signatures
        final res = await wClient.request(
          topic: topic,
          chainId: _chainMetadata.chainId,
          request: SessionRequestParams(
            method: _chainMetadata.method,
            params: [unSignedMessage, walletAddress],
          ),
        );
        signature = res.toString();
      }
    } catch (err) {
      debugPrint("Catch SendMessageForSigned error $err");
    }
    return signature;
  }

  @override
  Future<bool> onDisplayUri(Uri? uri) async {
    final link =
        formatNativeUrl(WalletConstants.deepLinkMetamask, uri.toString());
    var url = link.toString();
    if (!await canLaunchUrlString(url)) {
      return false;
    }
    return await launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  @override
  Future<void> disconnectWallet({required String topic}) async {
    await wClient.disconnect(
        topic: topic, reason: Errors.getSdkError(Errors.USER_DISCONNECTED));
  }
}
