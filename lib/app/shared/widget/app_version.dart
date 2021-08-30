import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final appName = snapshot.data?.appName ?? 'Talao';
            final version = snapshot.data?.version ?? '0.1.0';
            final buildNumber = snapshot.data?.buildNumber ?? '1';

            return Text(
              '$appName v$version ($buildNumber)',
              style: Theme.of(context).textTheme.caption!,
            );
          default:
            return const SizedBox();
        }
      },
    ));
  }
}
