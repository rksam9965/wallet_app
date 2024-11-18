import 'package:get_it/get_it.dart';
import 'metamask/metamask_connector_impl.dart';
import 'metamask/wallet_connector_service.dart';

final getIt = GetIt.instance;
initServices() {
  getIt.registerSingleton<WalletConnectorService>(MetamaskConnectorImpl());
}

WalletConnectorService get walletConnectorService => getIt.get();
