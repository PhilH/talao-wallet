import 'dart:convert';
import 'dart:io';
import 'package:bip39/bip39.dart' as bip39;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talao/app/interop/crypto_keys/crypto_keys.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/encryption.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:talao/app/shared/widget/base/text_field.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/wallet/wallet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecoveryCredentialPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => RecoveryCredentialPage(),
        settings: RouteSettings(name: '/recoveryCredentialPage'),
      );

  @override
  _RecoveryCredentialPageState createState() => _RecoveryCredentialPageState();
}

class _RecoveryCredentialPageState extends State<RecoveryCredentialPage> {
  late TextEditingController mnemonicController;
  late bool buttonEnabled;
  late bool edited;
}

class _RecoveryCredentialPageState extends State<RecoveryCredentialPage> {
  List<String>? _mnemonic;

  @override
  void initState() {
    super.initState();
    mnemonicController = TextEditingController();
    mnemonicController.addListener(() {
      setState(() {
        edited = mnemonicController.text.isNotEmpty;
        buttonEnabled = bip39.validateMnemonic(mnemonicController.text);
      });
    });

    edited = false;
    buttonEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.recoveryCredential,
      titleLeading: BackLeadingButton(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            children: [
              Text(
                l10n.recoveryCredentialPhrase,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 8.0),
              Text(
                l10n.recoveryCredentialPhraseExplanation,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          BaseTextField(
            label: l10n.recoveryMnemonicHintText,
            controller: mnemonicController,
            error: edited && !buttonEnabled ? l10n.recoveryMnemonicError : null,
          ),
          const SizedBox(height: 24.0),
          BaseButton.primary(
            context: context,
            textColor: Theme.of(context).colorScheme.onPrimary,
            gradient: buttonEnabled
                ? null
                : LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.shadow,
                      Theme.of(context).colorScheme.shadow
                    ],
                  ),
            onPressed: !buttonEnabled
                ? null
                : () async {
                    var appDir = (await getTemporaryDirectory()).path;
                    await Directory(appDir).delete(recursive: true);
                    var result = await FilePicker.platform.pickFiles(
                        type: FileType.custom, allowedExtensions: ['txt']);
                    if (result != null) {
                      var file = File(result.files.single.path!);
                      var text = await file.readAsString();
                      Map json = jsonDecode(text);
                      var encryption = Encryption(
                          cipherText: json['cipherText'],
                          authenticationTag: json['authenticationTag']);
                      var decryptedText = await CryptoKeys()
                          .decrypt(mnemonicController.text, encryption);
                      //todo: verify data
                      Map decryptedJson = jsonDecode(decryptedText);
                      List credentialJson = decryptedJson['credentials'];
                      var credentials = credentialJson.map(
                          (credential) => CredentialModel.fromJson(credential));
                      await context
                          .read<WalletCubit>()
                          .recoverWallet(credentials.toList());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(l10n.recoveryCredentialSuccessMessage(
                              '${credentials.length} ${credentials.length > 1 ? 'credentials' : 'credential'}'))));
                    }
                  },
            child: Text(l10n.recoveryCredentialButtonTitle),
          )
        ],
      ),
    );
  }
}
