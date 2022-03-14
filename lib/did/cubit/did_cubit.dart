import 'package:bloc/bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:logging/logging.dart';
import 'package:talao/did/cubit/did_state.dart';

class DIDCubit extends Cubit<DIDState> {
  final SecureStorageProvider? secureStorageProvider;
  final DIDKitProvider? didKitProvider;

  DIDCubit({this.didKitProvider, this.secureStorageProvider})
      : super(DIDStateDefault(did: '')) {
    load();
  }

  void load() async {
    final log = Logger('talao-wallet/DID/load');

    try {
      emit(DIDStateWorking());

      final key = (await secureStorageProvider!.get('key'))!;
      final did = didKitProvider!.keyToDID(Constants.defaultDIDMethod, key);

      emit(DIDStateDefault(did: did));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(DIDStateMessage(
          message: StateMessage.error('Failed to load DID. '
              'Check the logs for more information.')));
    }
  }
}