import 'package:flutter/material.dart';

class ManagerThemeController {
  ManagerThemeController._();

  static final ValueNotifier<ThemeMode> mode = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  static bool get isDark => mode.value == ThemeMode.dark;

  static void toggle() {
    mode.value = isDark ? ThemeMode.light : ThemeMode.dark;
  }
}

class ManagerPalette {
  const ManagerPalette._();

  static const Color _primary = Color(0xFF7C3AED);
  static const Color _danger = Color(0xFFFF3B30);

  static const Color _lightPageBg = Color(0xFFF5F4F8);
  static const Color _lightSurface = Color(0xFFF8F8FB);
  static const Color _lightBorder = Color(0xFFD7DBE3);
  static const Color _lightTitle = Color(0xFF1D2433);
  static const Color _lightMuted = Color(0xFF667085);
  static const Color _lightSubtle = Color(0xFFF1F0F5);
  static const Color _lightSubtleAlt = Color(0xFFEDECF3);
  static const Color _lightAppBarBg = Color(0xFFFFFFFF);
  static const Color _lightAppBarBorder = Color(0xFFE5E7EB);
  static const Color _lightAppBarAccent = Color(0xFFEDE9FE);

  // Dark palette matched to the provided reference.
  static const Color _darkPageBg = Color(0xFF08031A);
  static const Color _darkSurface = Color(0xFF1A1033);
  static const Color _darkBorder = Color(0xFF3A2370);
  static const Color _darkTitle = Color(0xFFF4F1FF);
  static const Color _darkMuted = Color(0xFF9AA3C4);
  static const Color _darkSubtle = Color(0xFF221246);
  static const Color _darkSubtleAlt = Color(0xFF26174C);
  static const Color _darkAppBarBg = Color(0xFF1A0E33);
  static const Color _darkAppBarBorder = Color(0xFF35205D);
  static const Color _darkAppBarAccent = Color(0xFF2A1A4D);
  static const Color _darkSidebarBase = Color(0xFF251046);
  static const Color _darkSidebarAccent = Color(0xFF5B21B6);
  static const Color _darkSidebarAccentSoft = Color(0x667C3AED);
  static const Color _darkSidebarBorder = Color(0x4D7C3AED);
  static const Color _darkDialogShadow = Color(0x80000000);
  static const Color _darkPopupShadow = Color(0x99000000);
  static const Color _darkOverlay = Color(0xA6000000);

  static bool get _isDark => ManagerThemeController.isDark;

  static Color get primary => _primary;
  static Color get danger => _danger;
  static Color get pageBg => _isDark ? _darkPageBg : _lightPageBg;
  static Color get surface => _isDark ? _darkSurface : _lightSurface;
  static Color get border => _isDark ? _darkBorder : _lightBorder;
  static Color get titleText => _isDark ? _darkTitle : _lightTitle;
  static Color get mutedText => _isDark ? _darkMuted : _lightMuted;
  static Color get subtleSurface => _isDark ? _darkSubtle : _lightSubtle;
  static Color get subtleSurfaceAlt =>
      _isDark ? _darkSubtleAlt : _lightSubtleAlt;
  static Color get appBarBg => _isDark ? _darkAppBarBg : _lightAppBarBg;
  static Color get appBarBorder =>
      _isDark ? _darkAppBarBorder : _lightAppBarBorder;
  static Color get appBarAccent =>
      _isDark ? _darkAppBarAccent : _lightAppBarAccent;
  static Color get sidebarBase =>
      _isDark ? _darkSidebarBase : const Color(0xFF5B21B6);
  static Color get sidebarAccent =>
      _isDark ? _darkSidebarAccent : const Color(0xFF7C3AED);
  static Color get sidebarAccentSoft =>
      _isDark ? _darkSidebarAccentSoft : const Color(0x4D7C3AED);
  static Color get sidebarBorder =>
      _isDark ? _darkSidebarBorder : const Color(0x337C3AED);
  static Color get overlay => _isDark ? _darkOverlay : const Color(0x80000000);
  static Color get dialogShadow =>
      _isDark ? _darkDialogShadow : const Color(0x1A7C3AED);
  static Color get popupShadow =>
      _isDark ? _darkPopupShadow : const Color(0x33000000);

  static ThemeData lightTheme() => _buildTheme(isDark: false);
  static ThemeData darkTheme() => _buildTheme(isDark: true);

  static ThemeData _buildTheme({required bool isDark}) {
    final Color background = isDark ? _darkPageBg : _lightPageBg;
    final Color surface = isDark ? _darkSurface : _lightSurface;
    final Color border = isDark ? _darkBorder : _lightBorder;
    final Color text = isDark ? _darkTitle : _lightTitle;
    final Color muted = isDark ? _darkMuted : _lightMuted;

    final ColorScheme scheme = ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: _primary,
      onPrimary: Colors.white,
      secondary: _primary,
      onSecondary: Colors.white,
      error: _danger,
      onError: Colors.white,
      surface: surface,
      onSurface: text,
      surfaceContainerHighest: border,
      onSurfaceVariant: muted,
      outline: border,
      outlineVariant: border,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: text,
      onInverseSurface: surface,
      inversePrimary: _primary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      dividerColor: border,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? _darkAppBarBg : _lightAppBarBg,
        foregroundColor: text,
        elevation: 0,
      ),
      textTheme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
      ).textTheme.apply(
        bodyColor: text,
        displayColor: text,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: surface,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        surfaceTintColor: surface,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surface,
        contentTextStyle: TextStyle(
          color: text,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
    );
  }
}
