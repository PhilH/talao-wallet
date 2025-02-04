import 'package:talao/app/shared/widget/base/markdown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => TermsPage(),
        settings: RouteSettings(name: '/termsPage'),
      );

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final languagesList = ['fr', 'it', 'es', 'de'];
    var filePath = 'en';
    if (languagesList.contains(localizations.localeName)) {
      filePath = localizations.localeName;
    }
    return MarkdownPage(
        title: localizations.onBoardingTosTitle,
        file: 'assets/terms/mobile_cgu_$filePath.md');
  }
}
