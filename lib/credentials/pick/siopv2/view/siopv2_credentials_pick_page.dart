import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/credentials/pick/siopv2/cubit/siopv2_credentials_pick_cubit.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/qr_code/qr_code_scan/model/siopv2_param.dart';
import 'package:talao/scan/scan.dart';
import 'package:talao/credentials/widget/list_item.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';

class SIOPV2CredentialPickPage extends StatefulWidget {
  final List<CredentialModel> credentials;
  final SIOPV2Param sIOPV2Param;

  const SIOPV2CredentialPickPage({
    Key? key,
    required this.credentials,
    required this.sIOPV2Param,
  }) : super(key: key);

  static Route route(
          {required List<CredentialModel> credentials,
          required SIOPV2Param sIOPV2Param}) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              SIOPV2CredentialPickCubit(scanCubit: context.read<ScanCubit>()),
          child: SIOPV2CredentialPickPage(
              credentials: credentials, sIOPV2Param: sIOPV2Param),
        ),
        settings: RouteSettings(name: '/SIOPV2CredentialPickPage'),
      );

  @override
  _SIOPV2CredentialPickPageState createState() =>
      _SIOPV2CredentialPickPageState();
}

class _SIOPV2CredentialPickPageState extends State<SIOPV2CredentialPickPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    OverlayEntry? _overlay;

    return BlocConsumer<SIOPV2CredentialPickCubit, SIOPV2CredentialPickState>(
      listener: (context, state) {
        if (state is SIOPV2CredentialPresentState) {
          if (state.loading) {
            _overlay = OverlayEntry(
              builder: (context) => WillPopScope(
                onWillPop: () => Future.value(false),
                child: AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  title: Center(
                    child: Text(l10n.loading),
                  ),
                ),
              ),
            );
            Overlay.of(context)!.insert(_overlay!);
          } else {
            _overlay!.remove();
            _overlay = null;
            Navigator.of(context).pop();
          }
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (context.read<SIOPV2CredentialPickCubit>().state.loading) {
              return false;
            }
            return true;
          },
          child: BasePage(
            title: l10n.credentialPickTitle,
            titleTrailing: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 16.0,
            ),
            navigation: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                height: kBottomNavigationBarHeight + 16,
                child: Tooltip(
                  message: l10n.credentialPickPresent,
                  child: Builder(builder: (context) {
                    return BaseButton.primary(
                      context: context,
                      onPressed: () {
                        context
                            .read<SIOPV2CredentialPickCubit>()
                            .presentCredentialToSIOPV2Request(
                                credential: widget.credentials[state.index],
                                sIOPV2Param: widget.sIOPV2Param);
                      },
                      child: Text(l10n.credentialPickPresent),
                    );
                  }),
                ),
              ),
            ),
            body: Column(
              children: <Widget>[
                Text(
                  l10n.siopV2credentialPickSelect,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 12.0),
                ...List.generate(
                  widget.credentials.length,
                  (index) => CredentialsListPageItem(
                    item: widget.credentials[index],
                    selected: state.index == index,
                    onTap: () =>
                        context.read<SIOPV2CredentialPickCubit>().toggle(index),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
