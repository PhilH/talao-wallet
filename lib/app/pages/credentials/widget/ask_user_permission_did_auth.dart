import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/src/provider.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/shared/widget/confirm_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AskUserPermissionDIDAuth extends StatefulWidget {
  const AskUserPermissionDIDAuth({
    Key? key,
  }) : super(key: key);

  @override
  State<AskUserPermissionDIDAuth> createState() =>
      _AskUserPermissionDIDAuthState();
}

class _AskUserPermissionDIDAuthState extends State<AskUserPermissionDIDAuth> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final localizations = AppLocalizations.of(context)!;
      final scanBloc = context.read<ScanBloc>();
      final state = scanBloc.state;
      final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => ConfirmDialog(
              title: localizations.confimrDIDAuth,
              yes: localizations.showDialogYes,
              no: localizations.showDialogNo,
            ),
          ) ??
          false;

      if (confirm && state is ScanStateCHAPIAskPermissionDIDAuth) {
        scanBloc.add(ScanEventCHAPIGetDIDAuth(
            state.keyId, state.done, state.uri,
            challenge: state.challenge, domain: state.domain));
      }
      await Modular.to.pushReplacementNamed('/credentials/list');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}