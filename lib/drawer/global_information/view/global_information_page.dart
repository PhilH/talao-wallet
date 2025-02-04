import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/shared/widget/app_version.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/did/cubit/did_cubit.dart';
import 'package:talao/drawer/global_information/widget/did_display.dart';
import 'package:talao/drawer/global_information/widget/issuer_verification_setting.dart';
import 'package:talao/drawer/profile/cubit/profile_cubit.dart';
import 'package:talao/l10n/l10n.dart';

class GlobalInformationPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => GlobalInformationPage(),
        settings: RouteSettings(name: '/globalInformationPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.globalInformationLabel,
      titleLeading: BackLeadingButton(),
      scrollView: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IssuerVerificationSetting(),
          DIDDisplay(
            isEnterpriseUser:
                context.read<ProfileCubit>().state.model.isEnterprise,
          ),
          const Spacer(),
          Center(
            child: Text(
              'DIDKit v' + context.read<DIDCubit>().didKitProvider.getVersion(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          const SizedBox(height: 16.0),
          AppVersion(),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
