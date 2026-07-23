import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primary = Color(0xFF00684F);
  static const Color primaryContainer = Color(0xFF1B8366);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFF1FFF7);
  static const Color inversePrimary = Color(0xFF7BD8B6);

  // Secondary Colors
  static const Color secondary = Color(0xFF006B54);
  static const Color secondaryContainer = Color(0xFF7CF5CE);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Surface Colors
  static const Color surface = Color(0xFFFCF9F8);
  static const Color surfaceVariant = Color(0xFFE5E2E1);
  static const Color surfaceDim = Color(0xFFDCD9D9);
  static const Color surfaceContainerLow = Color(0xFFF6F3F2);
  static const Color surfaceContainer = Color(0xFFF0EDEC);
  static const Color surfaceContainerHigh = Color(0xFFEBE7E7);
  static const Color surfaceContainerHighest = Color(0xFFE5E2E1);
  static const Color onSurface = Color(0xFF1C1B1B);
  static const Color onSurfaceVariant = Color(0xFF3E4944);

  // Outline Colors
  static const Color outline = Color(0xFF6E7A74);
  static const Color outlineVariant = Color(0xFFBDC9C2);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // Background
  static const Color background = Color(0xFFFCF9F8);
  static const Color white = Color(0xFFFFFFFF);

  // Semantic extras
  static const Color verifiedBadge = Color(0xFF1B8366);
  static const Color pricePrimary = Color(0xFF00684F);
  static const Color negotiableAmber = Color(0xFFD97706);

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: Color(0xFF007057),
        tertiary: Color(0xFF585C5C),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFF717574),
        onTertiaryContainer: Color(0xFFFAFDFC),
        error: error,
        onError: Colors.white,
        errorContainer: errorContainer,
        onErrorContainer: Color(0xFF93000A),
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        inverseSurface: Color(0xFF313030),
        onInverseSurface: Color(0xFFF3F0EF),
        inversePrimary: inversePrimary,
        background: background,
        onBackground: onSurface,
        surfaceVariant: surfaceVariant,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.manropeTextTheme(),
    );
    return base;
  }

  // Text Styles
  static TextStyle get displayLg => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.25,
        letterSpacing: -0.02 * 32,
        color: onSurface,
      );

  static TextStyle get headlineMd => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.33,
        color: onSurface,
      );

  static TextStyle get headlineSm => GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.4,
        color: onSurface,
      );

  static TextStyle get bodyLg => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: onSurface,
      );

  static TextStyle get bodyMd => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        color: onSurface,
      );

  static TextStyle get labelMd => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: onSurface,
      );

  static TextStyle get priceDisplay => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        height: 1.33,
        color: pricePrimary,
      );
}
