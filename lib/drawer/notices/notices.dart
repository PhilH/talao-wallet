import 'package:talao/app/shared/widget/base/markdown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoticesPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => NoticesPage(),
      );

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return MarkdownPage(
        title: localizations.noticesTitle, file: 'assets/notices.md');
  }
}
