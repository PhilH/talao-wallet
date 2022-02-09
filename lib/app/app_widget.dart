import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/interop/network/network_client.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/credentials/repositories/credential.dart';
import 'package:talao/app/pages/profile/blocs/did.dart';
import 'package:talao/app/pages/splash.dart';
import 'package:talao/app/shared/constants.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/deep_link/cubit/deep_link.dart';
import 'package:talao/query_by_example/query_by_example.dart';
import 'pages/credentials/blocs/wallet.dart';
import 'pages/profile/blocs/profile.dart';
import 'pages/qr_code/bloc/qrcode.dart';

class AppWidget extends StatefulWidget {
  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
  }

  ThemeData get _themeData {
    final themeData = ThemeData(
      brightness: Brightness.light,
      backgroundColor: UiKit.palette.background,
      primaryColor: UiKit.palette.primary,
      // ignore: deprecated_member_use
      accentColor: UiKit.palette.accent,
      textTheme: UiKit.text.textTheme,
    );

    return themeData;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeepLinkCubit>(
      create: (context) => DeepLinkCubit(),
      child: BlocProvider<QueryByExampleCubit>(
        create: (context) => QueryByExampleCubit(),
        child: BlocProvider<WalletBloc>(
          lazy: false,
          create: (context) => WalletBloc(CredentialsRepository())..checkKey(),
          child: BlocProvider<ScanBloc>(
            create: (context) => ScanBloc(
                DioClient(Constants.checkIssuerServerUrl, Dio()),
                context.read<WalletBloc>()),
            child: BlocProvider<QRCodeBloc>(
              create: (context) => QRCodeBloc(
                DioClient(Constants.checkIssuerServerUrl, Dio()),
                context.read<ScanBloc>(),
                context.read<QueryByExampleCubit>(),
              ),
              child: BlocProvider<ProfileBloc>(
                create: (context) => ProfileBloc(),
                child: BlocProvider<DIDBloc>(
                  create: (context) => DIDBloc(),
                  child: MaterialApp(
                    title: 'Credible',
                    routes: {
                      '/splash': (context) => SplashPage(),
                    },
                    initialRoute: '/splash',
                    theme: _themeData,
                    localizationsDelegates: [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const <Locale>[
                      Locale('en', ''),
                      Locale('pt', 'BR'),
                      Locale('fr', ''),
                      Locale('es', ''),
                      Locale('it', ''),
                      Locale('de', ''),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
