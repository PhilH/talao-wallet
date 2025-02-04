import 'dart:convert';
import 'dart:io';

import 'package:bip39/bip39.dart' as bip39;
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/interop/crypto_keys/crypto_keys.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/encryption/encryption.dart';
import 'package:talao/app/shared/model/message.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';

part 'recovery_credential_cubit.g.dart';

part 'recovery_credential_state.dart';

class RecoveryCredentialCubit extends Cubit<RecoveryCredentialState> {
  final WalletCubit walletCubit;

  RecoveryCredentialCubit({
    required this.walletCubit,
  }) : super(RecoveryCredentialState());

  void isMnemonicsValid(String value) {
    emit(
      state.copyWith(
          isTextFieldEdited: value.isNotEmpty,
          isMnemonicValid: bip39.validateMnemonic(value)),
    );
  }

  Future<void> recoverWallet(String mnemonic, FilePickerResult result) async {
    try {
      var file = File(result.files.single.path!);
      var text = await file.readAsString();
      Map json = jsonDecode(text) as Map<String, dynamic>;
      if (!json.containsKey('cipherText') ||
          !json.containsKey('authenticationTag') ||
          !(json['cipherText'] is String) ||
          !(json['authenticationTag'] is String)) {
        throw FormatException();
      }
      var encryption = Encryption(
          cipherText: json['cipherText'],
          authenticationTag: json['authenticationTag']);
      var decryptedText = await CryptoKeys().decrypt(mnemonic, encryption);
      Map decryptedJson = jsonDecode(decryptedText);
      if (!decryptedJson.containsKey('date') ||
          !decryptedJson.containsKey('credentials') ||
          !(decryptedJson['date'] is String)) {
        throw FormatException();
      }
      List credentialJson = decryptedJson['credentials'];
      var credentials = credentialJson
          .map((credential) => CredentialModel.fromJson(credential));
      await walletCubit.recoverWallet(credentials.toList());
      emit(state.copyWith(
          status: RecoveryCredentialStatus.success,
          recoveredCredentialLength: credentials.length));
    } on FormatException {
      emit(state.copyWith(status: RecoveryCredentialStatus.invalidJson));
    } catch (e) {
      print(e.toString());
      if (e.toString().startsWith('Auth error')) {
        emit(state.copyWith(status: RecoveryCredentialStatus.authError));
      } else {
        emit(state.copyWith(status: RecoveryCredentialStatus.failure));
      }
    }
  }
}
