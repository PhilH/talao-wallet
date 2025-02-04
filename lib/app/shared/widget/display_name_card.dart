import 'package:flutter/material.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/l10n/l10n.dart';

class DisplayNameCard extends StatelessWidget {
  DisplayNameCard(this.item, this.style, {Key? key}) : super(key: key);
  final CredentialModel item;
  final TextStyle style;
  @override
  Widget build(BuildContext context) {
    final nameValue = getName(context);
    return Text(
      nameValue.toString(),
      maxLines: 1,
      overflow: TextOverflow.clip,
      style: style,
    );
  }

  String getName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    var _nameValue = getTranslation(item.credentialPreview.name, localizations);
    if (_nameValue == '') {
      _nameValue = item.display.nameFallback;
    }
    if (_nameValue == '') {
      _nameValue = item.credentialPreview.type.last;
    }

    return _nameValue;
  }
}
