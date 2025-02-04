import 'package:flutter/material.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/ui/theme.dart';
import 'package:talao/app/shared/widget/image_from_network.dart';

class DisplayIssuer extends StatelessWidget {
  const DisplayIssuer({
    Key? key,
    required this.issuer,
  }) : super(key: key);

  final Author issuer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Text('${localizations.issuer} '),
          Text(issuer.name,
              style: Theme.of(context).textTheme.credentialIssuer),
          Spacer(),
          (issuer.logo != '')
              ? Container(
                  height: 30,
                  child: ImageFromNetwork(
                    issuer.logo,
                    fit: BoxFit.cover,
                  ))
              : SizedBox(
                  height: 30,
                )
        ],
      ),
    );
  }
}
