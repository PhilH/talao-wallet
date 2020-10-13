import 'package:credible/app/pages/credentials/bloc.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/module.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef CredentialsStreamBuilder = Widget Function(
  BuildContext,
  List<CredentialModel>,
);

class CredentialsStream extends StatefulWidget {
  final CredentialsStreamBuilder child;

  const CredentialsStream({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  _CredentialsStreamState createState() => _CredentialsStreamState();
}

class _CredentialsStreamState extends State<CredentialsStream> {
  CredentialsBloc bloc = CredentialsModule.to.get<CredentialsBloc>();

  @override
  void initState() {
    super.initState();
    bloc.findAll();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<CredentialModel>>(
        initialData: [],
        stream: bloc.credentials$,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<CredentialModel>> snapshot,
        ) {
          final localizations = AppLocalizations.of(context);

          if (snapshot.hasError) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Palette.background,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: Text(localizations.genericError),
                ),
                body: Center(
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        tooltip: localizations.listActionRefresh,
                        icon: Icon(Icons.refresh),
                        onPressed: () {},
                      ),
                      const SizedBox(height: 16.0),
                      Text(localizations.genericError),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return widget.child(context, snapshot.data);
          }
        },
      );
}
