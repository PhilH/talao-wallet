import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme();

  static const Color darkPrimary = Color(0xffbb86fc);
  static const Color darkPrimaryVariant = Color(0xff3700B3);
  static const Color darkSecondary = Color(0xff03dac6);
  static const Color darkSecondaryVariant = Color(0xff03dac6);
  static const Color darkSurface = Color(0xff212121);
  static const Color darkBackground = Color(0xff121212);
  static const Color darkError = Color(0xffcf6679);
  static const Color darkOnPrimary = Colors.black;
  static const Color darkOnSecondary = Colors.black;
  static const Color darkOnSurface = Colors.white;
  static const Color darkOnBackground = Colors.white;
  static const Color darkOnError = Colors.black;

  static const Color lightPrimary = Color(0xff6200ee);
  static const Color lightPrimaryVariant = Color(0xff3700b3);
  static const Color lightSecondary = Color(0xff03dac6);
  static const Color lightSecondaryVariant = Color(0xff018786);
  static const Color lightSurface = Colors.white;
  static const Color lightBackground = Colors.white;
  static const Color lightError = Color(0xffb00020);
  static const Color lightOnPrimary = Colors.white;
  static const Color lightOnSecondary = Colors.black;
  static const Color lightOnSurface = Colors.black;
  static const Color lightOnBackground = Colors.black;
  static const Color lightOnError = Colors.white;

  static ThemeData get darkThemeData => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          primary: darkPrimary,
          primaryVariant: darkPrimaryVariant,
          secondary: darkSecondary,
          secondaryVariant: darkSecondaryVariant,
          surface: darkSurface,
          background: darkBackground,
          error: darkError,
          onPrimary: darkOnPrimary,
          onSecondary: darkOnSecondary,
          onSurface: darkOnSurface,
          onBackground: darkOnBackground,
          onError: darkOnError,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          subtitle1: GoogleFonts.poppins(
            color: const Color(0xFFFFFFFF),
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          subtitle2: GoogleFonts.poppins(
            color: const Color(0xFF8B8C92),
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          bodyText1: GoogleFonts.montserrat(
            color: const Color(0xFF8B8C92),
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: GoogleFonts.montserrat(
            color: const Color(0xFFFFFFFF),
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
          ),
          button: GoogleFonts.poppins(
            color: const Color(0xFFFFFFFF),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          overline: GoogleFonts.montserrat(
            color: const Color(0xFFFFFFFF),
            fontSize: 10.0,
            letterSpacing: 0.0,
          ),
          caption: GoogleFonts.montserrat(
            color: const Color(0xFFFFFFFF),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: IconThemeData(color: const Color(0xFFFFFFFF)),
      );

  static ThemeData get lightThemeData => ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme(
          primary: lightPrimary,
          primaryVariant: lightPrimaryVariant,
          secondary: lightSecondary,
          secondaryVariant: lightSecondaryVariant,
          surface: lightSurface,
          background: lightBackground,
          error: lightError,
          onPrimary: lightOnPrimary,
          onSecondary: lightOnSecondary,
          onSurface: lightOnSurface,
          onBackground: lightOnBackground,
          onError: lightOnError,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          subtitle1: GoogleFonts.poppins(
            color: const Color(0xff212121),
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          subtitle2: GoogleFonts.poppins(
            color: const Color(0xFFA4A5AC),
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          bodyText1: GoogleFonts.montserrat(
            color: const Color(0xff212121),
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: GoogleFonts.montserrat(
            color: const Color(0xff212121),
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
          ),
          button: GoogleFonts.poppins(
            color: const Color(0xff212121),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          overline: GoogleFonts.montserrat(
            color: const Color(0xff212121),
            fontSize: 10.0,
            letterSpacing: 0.0,
          ),
          caption: GoogleFonts.montserrat(
            color: const Color(0xff212121),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: IconThemeData(color: const Color(0xff212121)),
      );
}

extension CustomColorScheme on ColorScheme {
  Color get transparent => Colors.transparent;

  Color get appBar => brightness == Brightness.light
      ? const Color(0xFFFFFFFF)
      : const Color(0xFF1D1D1D);

  Color get shadow => brightness == Brightness.light
      ? const Color(0xFFADACAC)
      : const Color(0xFF1D1D1D).withOpacity(0.1);

  Color get backButton => brightness == Brightness.light
      ? const Color(0xFF1D1D1D)
      : const Color(0xFFADACAC);

  Color get selectedBottomBar => brightness == Brightness.light
      ? AppTheme.lightOnSurface
      : AppTheme.darkOnSurface;

  Color get borderColor => brightness == Brightness.light
      ? const Color(0xFFEEEAEA)
      : const Color(0xFF262525);

  Color get markDownH1 => brightness == Brightness.light
      ? AppTheme.lightOnSurface
      : const Color(0xFFDBD8D8);

  Color get markDownH2 => brightness == Brightness.light
      ? AppTheme.lightOnSurface
      : const Color(0xFFDBD8D8);

  Color get markDownP => brightness == Brightness.light
      ? AppTheme.lightOnSurface
      : const Color(0xFFADACAC);

  Color get markDownA => brightness == Brightness.light
      ? AppTheme.lightPrimaryVariant
      : AppTheme.darkSecondary;

  Color get subtitle1 => brightness == Brightness.light
      ? const Color(0xff212121)
      : const Color(0xFFFFFFFF);

  Color get subtitle2 => brightness == Brightness.light
      ? const Color(0xff212121)
      : const Color(0xFF8B8C92);

  Color get button => brightness == Brightness.light
      ? const Color(0xff212121)
      : const Color(0xFFEEEAEA);

  Color? get profileDummy =>
      brightness == Brightness.light ? Colors.grey[300] : Colors.grey[900];
}
