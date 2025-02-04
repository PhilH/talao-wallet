import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/didkit/didkit.dart';
import 'package:talao/app/interop/key_generation.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/mnemonic.dart';
import 'package:talao/did/cubit/did_cubit.dart';
import 'package:talao/drawer/profile/models/profile.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/onboarding/gen_phrase/cubit/onboarding_gen_phrase_cubit.dart';
import 'package:talao/personal/view/personal_page.dart';

class OnBoardingGenPhrasePage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => OnBoardingGenPhraseCubit(
            secureStorageProvider: SecureStorageProvider.instance,
            didCubit: context.read<DIDCubit>(),
            didKitProvider: DIDKitProvider.instance,
            keyGeneration: KeyGeneration(),
          ),
          child: OnBoardingGenPhrasePage(),
        ),
        settings: RouteSettings(name: '/onBoardingGenPhrasePage'),
      );

  @override
  _OnBoardingGenPhrasePageState createState() =>
      _OnBoardingGenPhrasePageState();
}

class _OnBoardingGenPhrasePageState extends State<OnBoardingGenPhrasePage> {
  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return BasePage(
      title: localizations.onBoardingGenPhraseTitle,
      titleLeading: BackLeadingButton(),
      scrollView: true,
      body: BlocConsumer<OnBoardingGenPhraseCubit, OnBoardingGenPhraseState>(
        listener: (context, state) async {
          if (state.status == OnBoardingGenPhraseStatus.success) {
            await Navigator.of(context).pushReplacement(
              PersonalPage.route(
                  isFromOnBoarding: true, profileModel: ProfileModel.empty()),
            );
          }
          if (state.status == OnBoardingGenPhraseStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: state.message!.color!,
              content: Text(state.message?.getMessage(context) ?? ''),
            ));
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    localizations.genPhraseInstruction,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    localizations.genPhraseExplanation,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              MnemonicDisplay(mnemonic: state.mnemonic),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.privacy_tip_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        localizations.genPhraseViewLatterText,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 42,
                child: BaseButton.primary(
                  context: context,
                  onPressed: state.status == OnBoardingGenPhraseStatus.loading
                      ? null
                      : () async {
                          await context
                              .read<OnBoardingGenPhraseCubit>()
                              .generateKey(context, state.mnemonic);
                        },
                  child: Text(localizations.onBoardingGenPhraseButton),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
