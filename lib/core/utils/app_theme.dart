import "package:flutter/material.dart";

abstract final class AppTheme {
  const AppTheme._();

  /// Light Theme
  static ColorScheme _lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF273A9F),
      surfaceTint: Color(0xFF4355B9),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF4F60C5),
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondary: Color(0xFF565C84),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFD0D5FF),
      onSecondaryContainer: Color(0xFF383F65),
      tertiary: Color(0xFF5A349C),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF7F5BC4),
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: Color(0xFFFBF8FF),
      background: Color(0xFFFBF8FF),
      onSurface: Color(0xFF1A1B22),
      onBackground: Color(0xFF1A1B22),
      onSurfaceVariant: Color(0xFF454652),
      outline: Color(0xFF757684),
      outlineVariant: Color(0xFFC5C5D4),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF2F3037),
      inversePrimary: Color(0xFFBAC3FF),
    );
  }

  static ThemeData get light => theme(_lightScheme());

  /// Dark Theme
  static ColorScheme _darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFBAC3FF),
      surfaceTint: Color(0xFFBAC3FF),
      onPrimary: Color(0xFF08218A),
      primaryContainer: Color(0xFF3547AB),
      onPrimaryContainer: Color(0xFFF1F0FF),
      secondary: Color(0xFFBEC4F2),
      onSecondary: Color(0xFF272E53),
      secondaryContainer: Color(0xFF343B60),
      onSecondaryContainer: Color(0xFFC8CEFC),
      tertiary: Color(0xFFD3BBFF),
      onTertiary: Color(0xFF3E1280),
      tertiaryContainer: Color(0xFF7652BA),
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF121319),
      background: Color(0xFF121319),
      onSurface: Color(0xFFE3E1EA),
      onBackground: Color(0xFFE3E1EA),
      onSurfaceVariant: Color(0xFFC5C5D4),
      outline: Color(0xFF8F909E),
      outlineVariant: Color(0xFF454652),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE3E1EA),
      inversePrimary: Color(0xFF4355B9),
    );
  }

  static ThemeData get dark => theme(_darkScheme());

  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        fontFamily: "jetbrains",
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: const TextTheme().apply(
          fontFamily: "jetbrains",
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );
}
