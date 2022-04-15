import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passbase_flutter/passbase_flutter.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/issuer_websites_page/feature/kyc_feature.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/wallet/cubit/wallet_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class IssuerWebsitesPage extends StatelessWidget {
  final String? issuerFilter;

  const IssuerWebsitesPage(
    this.issuerFilter, {
    Key? key,
  }) : super(key: key);

  static Route route(String? issuerType) => MaterialPageRoute(
        builder: (context) => IssuerWebsitesPage(issuerType),
        settings: RouteSettings(name: '/issuerWebsitesPage'),
      );
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.issuerWebsitesTitle,
      titleLeading: BackLeadingButton(),
      body: Column(
        children: [
          BaseButton.primary(
            context: context,
            onPressed: () {
              _launchURL('https://talao.co/emailpass');
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.language),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(l10n.emailPassCredential),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          BaseButton.primary(
            context: context,
            onPressed: () {
              _launchURL('https://talao.co/phonepass');
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.phone),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(l10n.phonePassCredential),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          KYCButton(),
        ],
      ),
    );
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}

class KYCButton extends StatelessWidget {
  KYCButton({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    /// Sending email and DID to passbase
    final walletCubit = context.read<WalletCubit>();
    final hasMetadata = setKYCMetadat(walletCubit);
    final l10n = context.l10n;

    return hasMetadata
        ? Stack(
            children: [
              BaseButton.primary(
                context: context,
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: PassbaseButton(
                  height: 49,
                  onFinish: (identityAccessKey) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  onSubmitted: (identityAccessKey) {
                    // do stuff in case of success
                  },
                  onError: (errorCode) {
                    // do stuff in case of cancel
                  },
                  onStart: () {
                    // do stuff in case of start
                  },
                ),
              ),
            ],
          )
        : BaseButton.primary(
            context: context,
            onPressed: () async {
              await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  contentPadding: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 16.0,
                    left: 24.0,
                    right: 24.0,
                  ),
                  title: Text(
                    l10n.needEmailPass,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: BaseButton.transparent(
                              borderColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              textColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              context: context,
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text('OK'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Verify me'),
            ),
          );
  }
}
