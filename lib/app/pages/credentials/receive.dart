import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/widget/document.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/text_field_dialog.dart';
import 'package:talao/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CredentialsReceivePage extends StatefulWidget {
  final Uri url;
  final void Function(CredentialModel) onSubmit;

  const CredentialsReceivePage({
    Key? key,
    required this.url,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _CredentialsReceivePageState createState() => _CredentialsReceivePageState();
}

class _CredentialsReceivePageState extends State<CredentialsReceivePage> {
  final VoidCallback goBack = () {
    Modular.to.pushReplacementNamed('/credentials/list');
  };

  @override
  Widget build(BuildContext context) {
    // TODO: Add proper localization
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      padding: const EdgeInsets.all(24.0),
      title: localizations.credentialReceiveTitle,
      titleTrailing: IconButton(
        onPressed: goBack,
        icon: Icon(
          Icons.close,
          color: UiKit.palette.icon,
        ),
      ),
      body: BlocConsumer<ScanBloc, ScanState>(
        listener: (context, state) {
          if (state is ScanStateSuccess) {
            goBack();
          }
        },
        builder: (context, state) {
          if (state is ScanStateWorking) {
            return LinearProgressIndicator();
          }

          if (state is ScanStatePreview) {
            final credential = CredentialModel.fromJson(state.preview);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: [
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.175,
                    //   height: MediaQuery.of(context).size.width * 0.175,
                    //   decoration: BoxDecoration(
                    //     color: Colors.black45,
                    //     borderRadius: BorderRadius.circular(16.0),
                    //   ),
                    // ),
                    // const SizedBox(width: 16.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TooltipText(
                          text:
                              '${widget.url.host} ${localizations.credentialReceiveHost}',
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                DocumentWidget(model: credential),
                const SizedBox(height: 24.0),
                BaseButton.primary(
                  onPressed: () async {
                    final alias = await showDialog<String>(
                      context: context,
                      builder: (context) => TextFieldDialog(
                        title:
                            'Do you want to give an alias to this credential?',
                      ),
                    );

                    widget.onSubmit(CredentialModel.copyWithAlias(
                        oldCredentialModel: credential, newAlias: alias));
                  },
                  child: Text(localizations.credentialReceiveConfirm),
                ),
                const SizedBox(height: 8.0),
                BaseButton.transparent(
                  onPressed: goBack,
                  child: Text(localizations.credentialReceiveCancel),
                ),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}
