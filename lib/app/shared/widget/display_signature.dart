import 'package:flutter/material.dart';
import 'package:talao/app/shared/model/signature.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:talao/app/shared/widget/image_from_network.dart';

class DisplaySignatures extends StatelessWidget {
  const DisplaySignatures({
    Key? key,
    required this.localizations,
    required this.item,
  }) : super(key: key);

  final AppLocalizations localizations;
  final Signature item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CredentialField(title: localizations.signedBy, value: item.name),
        item.image != ''
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  child: ImageFromNetwork(item.image),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
