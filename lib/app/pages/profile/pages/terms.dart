import 'package:talao/app/shared/widget/base/markdown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return MarkdownPage(
        title: localizations.onBoardingTosTitle,
        file: localizations.localeName == 'fr'
            ? 'assets/cgu_fr.md'
            : 'assets/cgu_en.md');
  }
}
