import 'package:talao/app/shared/widget/base/button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/onboarding/second/view/onboarding_second_page.dart';
import 'package:talao/onboarding/tos/view/onboarding_tos_page.dart';

class OnBoardingStartPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (context) => OnBoardingStartPage(),
      settings: RouteSettings(name: '/onBoardingFirstPage'),
    );
  }

  @override
  State<OnBoardingStartPage> createState() => _OnBoardingStartPageState();
}

class _OnBoardingStartPageState extends State<OnBoardingStartPage> {
  var animate = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(OnBoardingSecondPage.route());
        },
        onHorizontalDragUpdate: (drag) async {
          if (animate && drag.delta.dx < -2) {
            disableAnimation();
            await Navigator.of(context).push(
              OnBoardingSecondPage.route(),
            );
          }
        },
        child: BasePage(
          scrollView: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/image/slide_1.png',
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  l10n.appPresentation1,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
          navigation: Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 15,
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.circle,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.2),
                            size: 15,
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.circle,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.2),
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    BaseButton.primary(
                      context: context,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacement(OnBoardingTosPage.route());
                      },
                      child: Text(l10n.onBoardingStartButton),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void disableAnimation() {
    animate = false;
    Future.delayed(Duration(seconds: 1), () {
      animate = true;
    });
  }
}
