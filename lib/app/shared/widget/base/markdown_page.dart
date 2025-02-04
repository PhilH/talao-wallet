import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownPage extends StatelessWidget {
  final String title;
  final String file;

  final _log = Logger('talao-wallet/markdown_page');

  MarkdownPage({Key? key, required this.title, required this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      titleLeading: BackLeadingButton(),
      scrollView: false,
      padding: const EdgeInsets.all(0.0),
      body: FutureBuilder<String>(
          future: _loadFile(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Markdown(
                data: snapshot.data!,
                styleSheet: MarkdownStyleSheet(
                  h1: TextStyle(
                      color: Theme.of(context).colorScheme.markDownH1),
                  h2: TextStyle(
                      color: Theme.of(context).colorScheme.markDownH2),
                  a: TextStyle(color: Theme.of(context).colorScheme.markDownA),
                  p: TextStyle(color: Theme.of(context).colorScheme.markDownP),
                ),
                onTapLink: (text, href, title) => _onTapLink(href),
              );
            }

            if (snapshot.error != null) {
              _log.severe(
                  'something went wrong when loading $file', snapshot.error);
              return Container();
            }

            return Spinner();
          }),
    );
  }

  Future<String> _loadFile() async {
    return await rootBundle.loadString(file);
  }

  void _onTapLink(String? href) async {
    if (href == null) return;

    if (await canLaunchUrl(Uri.parse(href))) {
      await launchUrl(Uri.parse(href));
    } else {
      _log.severe('cannot launch url: $href');
    }
  }
}
